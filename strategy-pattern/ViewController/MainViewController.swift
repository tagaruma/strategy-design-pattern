//
//  MainViewController.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 07.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import UIKit

protocol PersistenceController {
    var dataSource: PersistenceStrategy { get set }
    var contacts: [Contact] { get set }

    func updateDataSource(_ storage: Storage)
}


class MainViewController: BaseViewController, PersistenceController {
    var dataSource: PersistenceStrategy = CoreDataStrategy() {
        didSet {
            reloadTableViewData()
        }
    }

    var contacts: [Contact] = [] {
        didSet { tableView.reloadData() }
    }

    func updateDataSource(_ storage: Storage) {
        let strategy: PersistenceStrategy

        switch storage {
        case .coreData:
            strategy = CoreDataStrategy()
        case .userDefaults:
            strategy = UserDefaultsStrategy()
        case .nSKeyedArchiver:
            strategy = NSKeyedArchiverStrategy()
        case .realm:
            strategy = RealmStrategy()
        }

        self.dataSource = strategy
    }

    private let cellReuseIdentifier: String = String(describing: UITableViewCell.self)

    private lazy var dataSourceButton = UIBarButtonItem(
        barButtonSystemItem: .organize,
        target: self,
        action: #selector(touchUpInside(dataSourceButton:))
    )

    private lazy var addButton = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(touchUpInside(addButton:))
    )

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()
}

// MARK: - Life Cycle

extension MainViewController {
    override func loadView() {
        super.loadView()

        setUpSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Strategy Design Pattern"
        navigationItem.leftBarButtonItem = dataSourceButton
        navigationItem.rightBarButtonItem = addButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadTableViewData()
    }
}

// MARK: - Layout

extension MainViewController {
    private func setUpSubviews() {
        view.addSubview(tableView)
        tableView.addAnchors(
            top: view.layoutGuide.topAnchor,
            bottom: view.layoutGuide.bottomAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor
        )
    }
}

// MARK: - Actions

extension MainViewController {
    private func reloadTableViewData() {
        dataSource.getItems { [weak self] contacts in
            self?.contacts = contacts.reversed()
        }
    }
}

// MARK: - UIButton

extension MainViewController {
    @objc private func touchUpInside(dataSourceButton: UIButton) {
        dataSourceButtonPressed()
    }

    @objc private func touchUpInside(addButton: UIButton) {
        addButtonPressed()
    }
}

// MARK: - Actions

extension MainViewController {
    private func dataSourceButtonPressed() {
        let alertController = UIAlertController(title: "Select Persistence Storage", message: nil, preferredStyle: .actionSheet)

        for type in Storage.allCases {
            alertController.addAction(UIAlertAction(title: type.title, style: .default) { action in
                if action.title == type.title {
                    self.updateDataSource(type)
                }
            })
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    private func addButtonPressed() {
        let viewController = ContactViewController(dataSource: dataSource)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        cell.textLabel?.text = "Name: \(contacts[indexPath.row].firstName) \(contacts[indexPath.row].lastName)"
        cell.detailTextLabel?.text = "Phone: \(contacts[indexPath.row].phone)"

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Contacts stored in \(dataSource.dataSource.title)"
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = ContactViewController(dataSource: dataSource, contact: contacts[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.deleteItem(contacts[indexPath.row]) { [weak self] success in
                if success {
                    self?.reloadTableViewData()
                }
            }
        }
    }
}

//
//  ContactViewController.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import UIKit
import CoreData

class ContactViewController: BaseViewController {
    private var dataSource: PersistenceStrategy
    private var contact: Contact?

    private lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate

    private lazy var saveButton = UIBarButtonItem(
        barButtonSystemItem: .save,
        target: self,
        action: #selector(touchUpInside(saveButton:))
    )

    private lazy var firstNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .lightGray
        label.text = "First Name"

        return label
    }()

    private lazy var firstNameTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .rgb(value: 250.0)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 5.0
        textField.returnKeyType = .next
        textField.clipsToBounds = true
        textField.textColor = .black
        textField.delegate = self

        return textField
    }()

    private lazy var lastNameLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .lightGray
        label.text = "Last Name"

        return label
    }()

    private lazy var lastNameTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .rgb(value: 250.0)
        textField.autocapitalizationType = .words
        textField.layer.cornerRadius = 5.0
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        textField.clipsToBounds = true
        textField.textColor = .black
        textField.delegate = self

        return textField
    }()

    private lazy var phoneLabel: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14.0)
        label.textColor = .lightGray
        label.text = "Phone Number"

        return label
    }()

    private lazy var phoneTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .rgb(value: 250.0)
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.keyboardType = .phonePad
        textField.layer.cornerRadius = 5.0
        textField.clipsToBounds = true
        textField.textColor = .black

        return textField
    }()

    private lazy var formMode: FormMode = contact == nil ? .add : .edit

    // MARK: - Init

    init(dataSource: PersistenceStrategy, contact: Contact? = nil) {
        self.dataSource = dataSource

        super.init(nibName: nil, bundle: nil)

        self.contact = contact
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Life Cycle

extension ContactViewController {
    override func loadView() {
        super.loadView()

        setUpSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Add Contact"
        navigationItem.rightBarButtonItem = saveButton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if formMode == .edit {
            firstNameTextField.text = contact?.firstName
            lastNameTextField.text = contact?.lastName
            phoneTextField.text = contact?.phone
        } else {
            firstNameTextField.becomeFirstResponder()
        }
    }
}

// MARK: - Layout

extension ContactViewController {
    private func setUpSubviews() {
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextField)

        firstNameLabel.addAnchors(
            top: view.layoutGuide.topAnchor, topPadding: 15.0,
            leading: view.leadingAnchor, leadingPadding: 15.0
        )
        firstNameTextField.addAnchors(
            top: firstNameLabel.bottomAnchor, topPadding: 5.0,
            leading: view.leadingAnchor, leadingPadding: 15.0,
            trailing: view.trailingAnchor, trailingPadding: 15.0,
            height: 32.0
        )
        lastNameLabel.addAnchors(
            top: firstNameTextField.bottomAnchor, topPadding: 15.0,
            leading: view.leadingAnchor, leadingPadding: 15.0
        )
        lastNameTextField.addAnchors(
            top: lastNameLabel.bottomAnchor, topPadding: 5.0,
            leading: view.leadingAnchor, leadingPadding: 15.0,
            trailing: view.trailingAnchor, trailingPadding: 15.0,
            height: 32.0
        )
        phoneLabel.addAnchors(
            top: lastNameTextField.bottomAnchor, topPadding: 15.0,
            leading: view.leadingAnchor, leadingPadding: 15.0
        )
        phoneTextField.addAnchors(
            top: phoneLabel.bottomAnchor, topPadding: 5.0,
            leading: view.leadingAnchor, leadingPadding: 15.0,
            trailing: view.trailingAnchor, trailingPadding: 15.0,
            height: 32.0
        )
    }
}

// MARK: - FormMode

extension ContactViewController {
    private enum FormMode {
        case add, edit
    }
}

// MARK: - UIButton

extension ContactViewController {
    @objc private func touchUpInside(saveButton: UIButton) {
        saveButtonPressed()
    }
}

// MARK: - Actions

extension ContactViewController {
    private func saveButtonPressed() {
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let phone = phoneTextField.text {
            if !firstName.isEmpty && !lastName.isEmpty && phone.isValidPhone {
                if formMode == .add {
                    let contact = Contact(firstName: firstName, lastName: lastName, phone: phone)
                    addNewContact(contact)
                } else {
                    if let currentContact = contact {
                        let contact = Contact(id: currentContact.id, firstName: firstName, lastName: lastName, phone: phone)
                        updateContact(contact)
                    }
                }
            } else {
                showAlertController(
                    title: "Oops",
                    message: "Some information is invalid or missing, please fill in all fields correctly"
                )
            }
        }
    }

    private func addNewContact(_ contact: Contact) {
        dataSource.addItem(contact) { [weak self] success in
            if success {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showAlertController(title: "Oops", message: "Something went wrong, couldn't save contact")
            }
        }
    }

    private func updateContact(_ contact: Contact) {
        dataSource.updateItem(contact) { [weak self] success in
            if success {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.showAlertController(title: "Oops", message: "Something went wrong, couldn't update contact")
            }
        }
    }
}

// MARK: - UIAlertController

extension ContactViewController {
    private func showAlertController(title: String, message: String) {
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            phoneTextField.becomeFirstResponder()
        }

        return true
    }
}

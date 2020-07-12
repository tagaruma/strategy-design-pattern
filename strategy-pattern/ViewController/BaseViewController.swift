//
//  BaseViewController.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 07.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 12.0, *) {
            if view.traitCollection.userInterfaceStyle == .dark {
                view.backgroundColor = .black
            } else {
                view.backgroundColor = .white
            }
        } else {
            view.backgroundColor = .white
        }
    }
}


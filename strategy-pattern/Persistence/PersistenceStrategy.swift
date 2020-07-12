//
//  PersistenceStrategy.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import Foundation

protocol PersistenceStrategy: class {
    var dataSource: Storage { get }

    func addItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void)
    func updateItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void)
    func deleteItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void)
    func getItems(completionHandler: @escaping ([Contact]) -> Void)
}

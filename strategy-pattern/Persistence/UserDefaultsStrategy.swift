//
//  UserDefaultsStrategy.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import UIKit

class UserDefaultsStrategy: PersistenceStrategy {
    var dataSource: Storage = .userDefaults

    private lazy var userDefaults: UserDefaults = .standard

    func addItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        getItems { contacts in
            var contacts = contacts
            contacts.append(item)

            if let encoded = try? JSONEncoder().encode(contacts) {
                self.userDefaults.set(encoded, forKey: "Contacts")
                completionHandler(true)
            }
        }
    }

    func updateItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        getItems { contacts in
            for var contact in contacts where contact.id == item.id {
                contact.firstName = item.firstName
                contact.lastName = item.lastName
                contact.phone = item.phone
            }

            if let encoded = try? JSONEncoder().encode(contacts) {
                self.userDefaults.set(encoded, forKey: "Contacts")
                completionHandler(true)
            }
        }
    }

    func deleteItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        getItems { contacts in
            var contacts = contacts

            for (index, contact) in contacts.enumerated() where contact.id == item.id {
                contacts.remove(at: index)
            }

            if let encoded = try? JSONEncoder().encode(contacts) {
                self.userDefaults.set(encoded, forKey: "Contacts")
                completionHandler(true)
            }
        }
    }

    func getItems(completionHandler: @escaping ([Contact]) -> Void) {
        if let data = userDefaults.value(forKey: "Contacts") as? Data {
            if let contacts = try? JSONDecoder().decode(Array<Contact>.self, from: data) {
                completionHandler(contacts)
            } else {
                completionHandler([])
            }
        } else {
            completionHandler([])
        }
    }
}

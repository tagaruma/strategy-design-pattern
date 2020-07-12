//
//  NSKeyedArchiverStrategy.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import Foundation

class NSKeyedArchiverStrategy: PersistenceStrategy {
    private static let urlComponent = "Contacts"

    var dataSource: Storage = .nSKeyedArchiver

    private lazy var fileUrl: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]

        return documentsDirectory.appendingPathComponent(NSKeyedArchiverStrategy.urlComponent)
    }()

    func addItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        getItems { contacts in
            var contacts = contacts
            contacts.append(item)

            do {
                let codingContacts = contacts.map {
                    NSCodingContact(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, phone: $0.phone)
                }

                let data = try NSKeyedArchiver.archivedData(withRootObject: codingContacts, requiringSecureCoding: false)
                try data.write(to: self.fileUrl)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }

    func updateItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        getItems { contacts in
            do {
                let codingContacts = contacts.map {
                    NSCodingContact(
                        id: $0.id,
                        firstName: $0.id == item.id ? item.firstName : $0.firstName,
                        lastName: $0.id == item.id ? item.lastName : $0.lastName,
                        phone: $0.id == item.id ? item.phone : $0.phone
                    )
                }

                let data = try NSKeyedArchiver.archivedData(withRootObject: codingContacts, requiringSecureCoding: false)
                try data.write(to: self.fileUrl)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }

    func deleteItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        getItems { contacts in
            var contacts = contacts

            for (index, contact) in contacts.enumerated() where contact.id == item.id {
                contacts.remove(at: index)
            }

            do {
                let codingContacts = contacts.map {
                    NSCodingContact(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, phone: $0.phone)
                }

                let data = try NSKeyedArchiver.archivedData(withRootObject: codingContacts, requiringSecureCoding: false)
                try data.write(to: self.fileUrl)
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }

    func getItems(completionHandler: @escaping ([Contact]) -> Void) {
        do {
            let data = try Data(contentsOf: fileUrl)

            if let codingContacts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [NSCodingContact] {
                let contacts = codingContacts.map {
                    Contact(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, phone: $0.phone)
                }
                
                completionHandler(contacts)
            } else {
                completionHandler([])
            }
        } catch {
            completionHandler([])
        }
    }
}

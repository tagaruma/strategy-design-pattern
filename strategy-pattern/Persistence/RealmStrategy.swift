//
//  RealmStrategy.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 10.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import RealmSwift

class RealmStrategy: PersistenceStrategy {
    var dataSource: Storage = .realm

    func addItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()

            let realmContact = RealmContact(id: item.id, firstName: item.firstName, lastName: item.lastName, phone: item.phone)

            try realm.write {
                realm.add(realmContact)

                completionHandler(true)
            }
        } catch {
            completionHandler(false)
        }
    }

    func updateItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()

            if let contactToUpdate = realm.objects(RealmContact.self).filter( { $0.id == item.id } ).first {
                try realm.write {
                    contactToUpdate.firstName = item.firstName
                    contactToUpdate.lastName = item.lastName
                    contactToUpdate.phone = item.phone
                    completionHandler(true)
                }
            } else {
                completionHandler(false)
            }
        } catch {
            completionHandler(false)
        }
    }

    func deleteItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()

            if let contactToDelete = realm.objects(RealmContact.self).filter( { $0.id == item.id } ).first {
                try realm.write {
                    realm.delete(contactToDelete)

                    completionHandler(true)
                }
            } else {
                completionHandler(false)
            }
        } catch {
            completionHandler(false)
        }
    }

    func getItems(completionHandler: @escaping ([Contact]) -> Void) {
        do {
            let realm = try Realm()
            let realmContacts = realm.objects(RealmContact.self)

            let contacts: [Contact] = realmContacts.map {
                Contact(id: $0.id, firstName: $0.firstName, lastName: $0.lastName, phone: $0.phone)
            }

            completionHandler(contacts)
        } catch {
            completionHandler([])
        }
    }
}

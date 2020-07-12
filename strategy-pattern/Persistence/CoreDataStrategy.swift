//
//  CoreDataStrategy.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStrategy: PersistenceStrategy {
    var dataSource: Storage = .coreData

    private lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate

    private var context: NSManagedObjectContext { appDelegate.persistentContainer.viewContext }

    func addItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        if let entity = NSEntityDescription.insertNewObject(forEntityName: "CoreDataContact", into: context) as? CoreDataContact {
            entity.id = item.id
            entity.firstName = item.firstName
            entity.lastName = item.lastName
            entity.phone = item.phone
        }

        do {
            try context.save()
            completionHandler(true)
        } catch {
            completionHandler(false)
        }
    }

    func updateItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)

        do {
            let result = try context.fetch(fetchRequest)

            if let objectToUpdate = result.first as? NSManagedObject {
                objectToUpdate.setValue(item.firstName, forKey: "firstName")
                objectToUpdate.setValue(item.lastName, forKey: "lastName")
                objectToUpdate.setValue(item.phone, forKey: "phone")

                try context.save()
                completionHandler(true)
            }
        } catch {
            completionHandler(false)
        }
    }

    func deleteItem(_ item: Contact, completionHandler: @escaping (Bool) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id)

        do {
            let result = try context.fetch(fetchRequest)

            if let objectToDelete = result.first as? NSManagedObject {
                context.delete(objectToDelete)

                try context.save()
                completionHandler(true)
            }
        } catch {
            completionHandler(false)
        }
    }

    func getItems(completionHandler: @escaping ([Contact]) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataContact")

        do {
            let result = try context.fetch(fetchRequest)

            if let coreDataContacts = result as? [CoreDataContact] {
                let contacts = coreDataContacts.map {
                    Contact(id: $0.id!, firstName: $0.firstName!, lastName: $0.lastName!, phone: $0.phone!)
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

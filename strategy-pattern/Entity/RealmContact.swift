//
//  RealmContact.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 10.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import RealmSwift

class RealmContact: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phone: String = ""

    // MARK: - Init

    convenience init(id: String = UUID().uuidString, firstName: String, lastName: String, phone: String) {
        self.init()
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}

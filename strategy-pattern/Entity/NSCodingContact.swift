//
//  NSCodingContact.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import Foundation

class NSCodingContact: NSObject, NSCoding {
    let id: String
    let firstName: String
    let lastName: String
    let phone: String

    // MARK: - Init

    init(id: String = UUID().uuidString, firstName: String, lastName: String, phone: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }

    // MARK: - NSCoding

    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(phone, forKey: "phone")
    }

    required convenience init?(coder: NSCoder) {
        guard let id = coder.decodeObject(forKey: "id") as? String,
            let firstName = coder.decodeObject(forKey: "firstName") as? String,
            let lastName = coder.decodeObject(forKey: "lastName") as? String,
            let phone = coder.decodeObject(forKey: "phone") as? String else { return nil }
        self.init(id: id, firstName: firstName, lastName: lastName, phone: phone)
    }
}

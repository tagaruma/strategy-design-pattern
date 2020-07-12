//
//  Contact.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 07.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String
    var phone: String
}


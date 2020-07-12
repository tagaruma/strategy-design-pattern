//
//  String+Utils.swift
//  builder-pattern
//
//  Created by Ruslan Garifulin on 07.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import Foundation

extension String {
    var isValidPhone: Bool {
        let regex = "[+0-9]{7,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

        return predicate.evaluate(with: self)
    }
}

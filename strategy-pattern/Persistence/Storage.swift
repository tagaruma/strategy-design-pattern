//
//  Storage.swift
//  strategy-pattern
//
//  Created by Ruslan Garifulin on 08.06.2020.
//  Copyright © 2020 Ruslan Garifulin. All rights reserved.
//

import Foundation

enum Storage: String, CaseIterable {
    case coreData
    case userDefaults
    case nSKeyedArchiver
    case realm

    var title: String {
        switch self {
        case .coreData:
            return "Core Data"
        case .userDefaults:
            return "User Defaults"
        case .nSKeyedArchiver:
            return "NSKeyedArchiver"
        case.realm:
            return "Realm"
        }
    }
}

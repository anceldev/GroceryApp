//
//  UserDefaults+Extensions.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 30/12/24.
//

import Foundation

extension UserDefaults {
    var userId: UUID? {
        get {
            guard let userIdAsString = string(forKey: "userId") else {
                return nil
            }
            return UUID(uuidString: userIdAsString)
        }
        set {
            set(newValue?.uuidString, forKey: "userId")
        }
    }
}

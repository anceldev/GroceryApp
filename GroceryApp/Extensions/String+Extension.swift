//
//  StringExtension.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation

extension String {
    var isEmptyOrWithespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

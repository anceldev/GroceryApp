//
//  ErrorWrapper.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 31/12/24.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    let guidance: String
}

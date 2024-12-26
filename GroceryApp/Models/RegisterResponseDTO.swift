//
//  RegisterResponseDTO.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation

struct RegisterResponseDTO: Codable {
    let error: Bool
    var reason: String? = nil
}

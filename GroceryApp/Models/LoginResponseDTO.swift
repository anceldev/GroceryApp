//
//  LoginResponseDTO.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation

struct LoginResponseDTO: Codable {
    let error: Bool
    var reason: String? = nil
    let token: String? = nil
    let userId: UUID? = nil
}

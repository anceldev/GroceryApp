//
//  GroceryCategoriesResponseDTO+Extensions.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 30/12/24.
//

import Foundation
import GroceryAppShareDTO

extension GroceryCategoryResponseDTO: Identifiable, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    public static func == (lhs: GroceryCategoryResponseDTO, rhs: GroceryCategoryResponseDTO) -> Bool {
        return lhs.id == rhs.id
    }
}

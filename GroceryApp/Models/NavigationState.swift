//
//  NavigationState.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation
import Observation
import GroceryAppShareDTO

enum GroceryError: Error {
    case login
}

enum Route: Hashable {
    case login
    case register
    case groceryCategoryList
    case groceryCategoryDetail(GroceryCategoryResponseDTO)
}

@Observable
class AppState {
    var routes: [Route] = []
    var errorWrapper: ErrorWrapper?
}

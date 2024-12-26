//
//  NavigationState.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation
import Observation

enum Route: Hashable {
    case login
    case register
    case groceryCategoryList
}

@Observable
class AppState {
    var routes: [Route] = []
}

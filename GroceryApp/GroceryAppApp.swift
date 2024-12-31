//
//  GroceryAppApp.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 25/12/24.
//

import SwiftUI

@main
struct GroceryAppApp: App {
    @State private var groceryVM = GroceryViewModel()
    @State private var appState = AppState()
    
    var body: some Scene {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "authToken")
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                Group {
                    if token == nil {
                        RegistrationScreen()
                    } else {
                        GroceryCategoryListScreen()
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .register:
                        RegistrationScreen()
                    case .login:
                        LoginScreen()
                    case .groceryCategoryList:
                        GroceryCategoryListScreen()
                    case .groceryCategoryDetail(let groceryCategory):
                        GroceryDetailScreen(groceryCategory: groceryCategory)
                    }
                }
            }
            .environment(groceryVM)
            .environment(appState)
        }
    }
}

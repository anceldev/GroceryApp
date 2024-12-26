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
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                RegistrationScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .register: RegistrationScreen()
                        case .login: LoginScreen()
                        case .groceryCategoryList: Text("Grocery List View")
                        }
                    }
            }
            .environment(groceryVM)
            .environment(appState)
        }
    }
}

//
//  RegistrationScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @Environment(GroceryViewModel.self) private var groceryVM
    @Environment(AppState.self) private var appState
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    private let httpClient = HTTPClient()
    
    private var isFormValid: Bool {
        !username.isEmptyOrWithespace && !password.isEmptyOrWithespace && (password.count >= 6 && password.count <= 10)
    }
    
    var body: some View {
        Form {
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            HStack {
                Button("Register") {
                    Task {
                        await register()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isFormValid)
                Spacer(minLength: 0)
                Button {
                    appState.routes.append(.login)
                } label: {
                    Text("Go to login")
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.purple)

            }
            if errorMessage != "" {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle("Registration")
    }
    
    private func register() async {
        do {
            let registerResponseDTO = try await groceryVM.register(username: username, password: password)
            if !registerResponseDTO.error {
                appState.routes.append(.login)
            }
        } catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
}

struct RegistrationScreenContainer: View {
    @State private var groceryVM = GroceryViewModel()
    @State private var appState = AppState()
    var body: some View {
        NavigationStack(path: $appState.routes) {
            RegistrationScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .register: RegistrationScreen()
                    case .login: LoginScreen()
                    case .groceryCategoryList: Text("Grocery Category List")
                    }
                }
        }
        .environment(groceryVM)
        .environment(appState)
    }
}

#Preview {
    RegistrationScreenContainer()
}

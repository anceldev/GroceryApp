//
//  LoginScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import SwiftUI

struct LoginScreen: View {
    
    @Environment(GroceryViewModel.self) private var groceryVM
    @Environment(AppState.self) private var appState
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    private let httpClient = HTTPClient()
    
    private var isFormValid: Bool {
        !username.isEmptyOrWithespace && !password.isEmptyOrWithespace
    }
    
    var body: some View {
        @Bindable var appState = appState
        Form {
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            HStack {
                Button("Login") {
                    Task {
                        await login()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(!isFormValid)
                Spacer(minLength: 0)
                Button("Register") {
                    appState.routes.append(.register)
                }
                .buttonStyle(.borderless)
            }
            Text(errorMessage)
                .foregroundStyle(.red)
        }
        .navigationTitle("Login")
        .navigationBarBackButtonHidden()
        .sheet(item: $appState.errorWrapper) { errorWrapper in
            ErrorView(errorWrapper: errorWrapper)
                .presentationDetents([.fraction(0.25)])
        }
    }
    
    private func login() async {
        do {
            let loginResponseDTO = try await groceryVM.login(username: username, password: password)
            if loginResponseDTO.error {
                errorMessage = loginResponseDTO.reason ?? ""
                appState.errorWrapper = ErrorWrapper(error: GroceryError.login, guidance: loginResponseDTO.reason ?? "")
            } else {
                appState.routes.append(.groceryCategoryList)
            }
        } catch {
            print(error)
            appState.errorWrapper = ErrorWrapper(error: error, guidance: error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        LoginScreen()
            .environment(GroceryViewModel())
            .environment(AppState())
    }
}

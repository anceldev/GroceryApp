//
//  Grocery.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation
import Observation

@Observable
final class GroceryViewModel {
    
    let httpClient = HTTPClient()
    
    func register(username: String, password: String) async throws -> RegisterResponseDTO {
        let registerData = [
            "username": username,
            "password" : password
        ]
        let resource = try Resource(
            url: Constants.Urls.register,
            method: .post(JSONEncoder().encode(registerData)),
            modelType: RegisterResponseDTO.self
        )
        let registerResponseDTO = try await httpClient.load(resource)
        return registerResponseDTO
    }
    
    func login(username: String, password: String) async throws -> LoginResponseDTO {
        let loginData = [
            "username": username,
            "password": password
        ]
        let resource = try Resource(
            url: Constants.Urls.login,
            method: .post(JSONEncoder().encode(loginData)),
            modelType: LoginResponseDTO.self
        )
        
        let loginResponseDTO = try await httpClient.load(resource)
        
        if !loginResponseDTO.error && loginResponseDTO.token != nil && loginResponseDTO.userId != nil {
            let defaults = UserDefaults.standard
            defaults.set(loginResponseDTO.token, forKey: "authToken")
            defaults.set(loginResponseDTO.userId!.uuidString, forKey: "userId")
        }
        return loginResponseDTO
    }
}
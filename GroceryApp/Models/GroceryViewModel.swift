//
//  Grocery.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 26/12/24.
//

import Foundation
import Observation
import GroceryAppShareDTO

@Observable
final class GroceryViewModel {
    
    var groceryCategories = [GroceryCategoryResponseDTO]()
    
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
    
    func populateGRoceryCategories() async throws {
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        let resource = Resource(
            url: Constants.Urls.groceryCategoriesBy(userId: userId),
            modelType: [GroceryCategoryResponseDTO].self
        )
        self.groceryCategories = try await httpClient.load(resource)
    }
    
    func saveGroceryCategoryDTO(_ groceryCategoryRequestDTO: GroceryCategoryRequestDTO) async throws {
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        let resource = try Resource(
            url: Constants.Urls.saveGroceryCategoryBy(userId: userId),
            method: .post(JSONEncoder().encode(groceryCategoryRequestDTO)),
            modelType: GroceryCategoryResponseDTO.self
        )
        let groceryCategory = try await httpClient.load(resource)
        groceryCategories.append(groceryCategory)
    }
}

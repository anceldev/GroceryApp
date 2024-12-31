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
    var groceryCategory: GroceryCategoryResponseDTO?
    var groceryItems = [GroceryItemResponseDTO]()
    
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
    
    func logout() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "authToken")
    }
    
    func populateGroceryItemsBy(groceryCategoryId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        let resource = Resource(
            url: Constants.Urls.groceryItemsBy(
                userId: userId,
                groceryCategoryId: groceryCategoryId
            ),
            modelType: [GroceryItemResponseDTO].self
        )
        
        groceryItems = try await httpClient.load(resource)
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
    
    func saveGroceryItem(_ groceryItemRequestDTO: GroceryItemRequestDTO, groceryCategoryId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = try Resource(
            url: Constants.Urls.saveGroceryItem(
                userId: userId,
                groceryCategoryId: groceryCategoryId
            ),
            method: .post(JSONEncoder().encode(groceryItemRequestDTO)),
            modelType: GroceryItemResponseDTO.self
        )
        
        let newGroceryItem = try await httpClient.load(resource)
        groceryItems.append(newGroceryItem)
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
    
    func deleteGroceryItem(groceryCategoryId: UUID, groceryItemId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = Resource(
            url: Constants.Urls.deleteGroceryItem(
                userId: userId,
                groceryCategoryId: groceryCategoryId,
                groceryItemId: groceryItemId
            ),
            method: .delete,
            modelType: GroceryItemResponseDTO.self
        )
        
        let deletedGroceryItem = try await httpClient.load(resource)
        
        groceryItems = groceryItems.filter({ $0.id != deletedGroceryItem.id })
    }
    
    func deleteGroceryCategory(groceryCategoryId: UUID) async throws {
        guard let userId = UserDefaults.standard.userId else {
            return
        }
        
        let resource = Resource(
            url: Constants.Urls.deleteGroceryCategories(userId: userId, groceryCategoryId: groceryCategoryId),
            method: .delete,
            modelType: GroceryCategoryResponseDTO.self
        )
        
        let deletedGroceryCategory = try await httpClient.load(resource)
        groceryCategories = groceryCategories.filter { $0.id != deletedGroceryCategory.id }
    }
}

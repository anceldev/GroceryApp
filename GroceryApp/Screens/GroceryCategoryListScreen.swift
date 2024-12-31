//
//  GroceryCategoryListScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 30/12/24.
//

import SwiftUI

struct GroceryCategoryListScreen: View {
    
    @Environment(GroceryViewModel.self) var groceryVM
    @Environment(\.dismiss) private var dismiss
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            if groceryVM.groceryCategories.isEmpty {
                Text("No grocery categories found.")
            } else {
                List{
                    ForEach(groceryVM.groceryCategories) { groceryCategory in
                        NavigationLink(value: Route.groceryCategoryDetail(groceryCategory)) {
                            HStack {
                                Circle()
                                    .fill(Color(hex: groceryCategory.colorCode))
                                    .frame(width: 25, height: 25)
                                Text(groceryCategory.title)
                            }
                        }
                    }
                    .onDelete(perform: deleteGroceryCategory)
                }
            }
        }
        .task {
            await fetchGroceryCategories()
        }
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Logout") {
                    print("Login out...")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = true
                } label: {
                    Image(systemName: "plus")
                }
                
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddGroceryCategoryScreen()
            }
        }
    }
    
    private func fetchGroceryCategories() async {
        do {
            try await groceryVM.populateGRoceryCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
    private func deleteGroceryCategory(at offsets: IndexSet) {
        offsets.forEach { index in
            let groceryCategory = groceryVM.groceryCategories[index]
            Task {
                do {
                    try await groceryVM.deleteGroceryCategory(groceryCategoryId: groceryCategory.id)
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

struct GroceryCategoryListScreenContainer: View {
    @State private var groceryVM = GroceryViewModel()
    @State private var appState = AppState()
    var body: some View {
        NavigationStack(path: $appState.routes) {
            GroceryCategoryListScreen()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .register:
                        RegistrationScreen()
                    case .login:
                        LoginScreen()
                    case .groceryCategoryList:
                        Text("Grocery Category List")
                    case .groceryCategoryDetail(let groceryCategory):
                        GroceryDetailScreen(groceryCategory: groceryCategory)
                    }
                }
        }
        .environment(groceryVM)
        .environment(appState)
    }
}

#Preview {
//    NavigationStack {
//        GroceryCategoryListScreen()
//            .environment(GroceryViewModel())
//    }
    GroceryCategoryListScreenContainer()
}

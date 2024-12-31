//
//  GroceryDetailScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 31/12/24.
//

import SwiftUI
import GroceryAppShareDTO

struct GroceryDetailScreen: View {
    
    let groceryCategory: GroceryCategoryResponseDTO
    @State private var isPresented = false
    @Environment(GroceryViewModel.self) var groceryVM
    
    var body: some View {
        VStack {
            if groceryVM.groceryItems.isEmpty {
                Text("No items found...")
            } else {
                GroceryItemListView(
                    groceryItems: groceryVM.groceryItems,
                    onDelete: deleteGroceryItem
                )
            }
        }
        .navigationTitle(groceryCategory.title)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add grocery item") {
                    isPresented = true
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                AddGroceryItemScreen()
                    .environment(groceryVM)
            }
        }
        .onAppear {
            groceryVM.groceryCategory = groceryCategory
        }
        .task {
            await populateGroceryItems()
        }
    }
    private func populateGroceryItems() async {
        do {
            try await groceryVM.populateGroceryItemsBy(groceryCategoryId: groceryCategory.id)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteGroceryItem(groceryItemId: UUID) {
        Task {
            do {
                try await groceryVM.deleteGroceryItem(groceryCategoryId: groceryCategory.id, groceryItemId: groceryItemId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack {
        GroceryDetailScreen(
            groceryCategory: GroceryCategoryResponseDTO(
                id: UUID(uuidString: "87bd03e8-2406-43c5-860a-2177a7c3d089")!,
                title: "Seafood",
                colorCode: "#312832"
            )
        )
        .environment(GroceryViewModel())
    }
}

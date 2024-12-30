//
//  GroceryCategoryListScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 30/12/24.
//

import SwiftUI

struct GroceryCategoryListScreen: View {
    
    @Environment(GroceryViewModel.self) var groceryVM
    
    var body: some View {
        List(groceryVM.groceryCategories) { groceryCategory in
            HStack {
                Circle()
                    .fill(Color(hex: groceryCategory.colorCode))
                    .frame(width: 25, height: 25)
                Text(groceryCategory.title)
            }
        }
        .task {
            await fetchGroceryCategories()
        }
        .navigationTitle("Categories")
    }
    
    private func fetchGroceryCategories() async {
        do {
            try await groceryVM.populateGRoceryCategories()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    GroceryCategoryListScreen()
        .environment(GroceryViewModel())
}

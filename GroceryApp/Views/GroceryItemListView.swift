//
//  GroceryItemListView.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 31/12/24.
//

import SwiftUI
import GroceryAppShareDTO

struct GroceryItemListView: View {
    
    let groceryItems: [GroceryItemResponseDTO]
    let onDelete: (UUID) -> Void
    
    var body: some View {
        List {
            ForEach(groceryItems) { groceryItem in
                Text(groceryItem.title)
            }
            .onDelete(perform: deleteGroceryItem)
        }
    }
    private func deleteGroceryItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let groceryItem = groceryItems[index]
            onDelete(groceryItem.id)
        }
    }
}

#Preview {
    GroceryItemListView(groceryItems: [], onDelete: { _ in })
}

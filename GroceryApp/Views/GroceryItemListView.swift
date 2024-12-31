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
    var body: some View {
        List {
            ForEach(groceryItems) { groceryItem in
                Text(groceryItem.title)
            }
        }
    }
}

#Preview {
    GroceryItemListView(groceryItems: [])
}

//
//  AddGroceryItemScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 31/12/24.
//

import SwiftUI
import GroceryAppShareDTO

struct AddGroceryItemScreen: View {
    
    @State private var title: String = ""
    @State private var price: Double? = nil
    @State private var quantity: Int? = nil
    
    @Environment(GroceryViewModel.self) var groceryVM
    @Environment(\.dismiss) private var dismiss
    
    private var isFormValid: Bool {
        guard let price = price,
              let quantity = quantity else {
            return false
        }
        return !title.isEmptyOrWithespace && price > 0 && quantity > 0
    }
    
    var body: some View {
        Form {
            TextField("Title", text: $title)
            TextField("Price", value: $price, format: .currency(code: Locale.current.currencySymbol ?? ""))
            TextField("Quantity", value: $quantity, format: .number)
        }
        .navigationTitle("New Grocery Item")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await saveGroceryItem()
                    }
                }.disabled(!isFormValid)
            }
        }
    }
    private func saveGroceryItem() async {
        guard let groceryCategory = groceryVM.groceryCategory,
        let price = price,
        let quantity = quantity
        else {
            return
        }
        let groceryItemRequestDTO = GroceryItemRequestDTO(
            title: title,
            price: price,
            quantity: quantity
        )
        do {
            try await groceryVM.saveGroceryItem(groceryItemRequestDTO, groceryCategoryId: groceryCategory.id)
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        AddGroceryItemScreen()
            .environment(GroceryViewModel())
    }
}

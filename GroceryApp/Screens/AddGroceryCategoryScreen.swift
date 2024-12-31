//
//  AddGroceryCategoryScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 27/12/24.
//

import SwiftUI
import GroceryAppShareDTO

struct AddGroceryCategoryScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(GroceryViewModel.self) var groceryVM
    @State private var title = ""
    @State private var colorCode = "#2ecc71"
    
    private var isFormValid: Bool {
        !title.isEmptyOrWithespace
    }
    var body: some View {
        Form {
            TextField("title", text: $title)
            ColorSelector(colorCode: $colorCode)
        }
        .navigationTitle("New Category")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Close") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        await saveGroceryCategory()
                    }
                }
                .disabled(!isFormValid)
            }
        }
    }
    private func saveGroceryCategory() async {
        let groceryCategoryRequestDTO = GroceryCategoryRequestDTO(
            title: title,
            colorCode: colorCode
        )
        do {
            try await groceryVM.saveGroceryCategoryDTO(groceryCategoryRequestDTO)
            dismiss()
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        AddGroceryCategoryScreen()
            .environment(GroceryViewModel())
    }
}

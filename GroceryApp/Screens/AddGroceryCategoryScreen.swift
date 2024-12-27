//
//  AddGroceryCategoryScreen.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 27/12/24.
//

import SwiftUI

struct AddGroceryCategoryScreen: View {
    
    @Environment(\.dismiss) private var dismiss
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
        
    }
}

#Preview {
    AddGroceryCategoryScreen()
}

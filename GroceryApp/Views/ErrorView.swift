//
//  ErrorView.swift
//  GroceryApp
//
//  Created by Ancel Dev account on 31/12/24.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    var body: some View {
        VStack {
            Text("Error has ocurred in the application.")
                .font(.headline)
                .padding(.bottom, 10)
            Text(errorWrapper.error.localizedDescription)
            Text(errorWrapper.guidance)
                .font(.caption)
        }
        .padding()
    }
}

#Preview {
    enum SampleError: Error {
        case operationFailed
    }
    return ErrorView(errorWrapper: .init(error: SampleError.operationFailed, guidance: "Operation has failed. Please try again later."))
}

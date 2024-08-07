//
//  CreateCategoryView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 24.07.24.
//

import SwiftUI

struct CreateCategoryView: View {
    @EnvironmentObject var viewModel: CategorySelectionViewModel

    @State private var categoryName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Kategorienname", text: $categoryName)

                Button("Kategorie hinzufügen") {
                    viewModel.createCategory(categoryName)
                    categoryName = ""
                    viewModel.isPresented = false
                }
            }
        }
    }
}

#Preview {
    CreateCategoryView()
        .environmentObject(NotesListViewModel())
}

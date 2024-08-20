//
//  CategoriesSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 24.07.24.
//

import SwiftUI

struct CategoriesSelectionView: View {
    @StateObject var viewModel = CategoriesSelectionViewModel()
    @Binding var selectedCategories: Set<CDCategory>

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredCategories, id: \.self) { category in
                HStack {
                    Text(category.name ?? "no name")
                    Spacer()
                    if selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedCategories.contains(category) {
                        selectedCategories.remove(category)
                    } else {
                        selectedCategories.insert(category)
                    }
                }
            }
            .listStyle(.plain)

            Button(action: {
                viewModel.isPresented = true
            }, label: {
                Text("Neue Kategorie hinzufügen")
            })
            Spacer()
        }
        .navigationTitle("Wähle Kategorien")
        .onAppear {
            viewModel.getCDCategories()
        }
        .sheet(isPresented: $viewModel.isPresented) {
            CreateCategoryView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    @State var selectedCategories: Set<CDCategory> = []

    return CategoriesSelectionView(selectedCategories: $selectedCategories)
}

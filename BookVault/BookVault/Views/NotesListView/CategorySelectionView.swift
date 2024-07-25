//
//  CategorySelectionView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 24.07.24.
//

import SwiftUI

struct CategorySelectionView: View {
    @EnvironmentObject var viewModel: NotesListViewModel

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredCategories, id: \.self) { category in
                HStack {
                    Text(category.name ?? "no name")
                    Spacer()
                    if viewModel.selectedCategories.contains(category) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if viewModel.selectedCategories.contains(category) {
                        viewModel.selectedCategories.remove(category)
                    } else {
                        viewModel.selectedCategories.insert(category)
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
    let viewModel = NotesListViewModel()
    viewModel.getCDCategories()

    return CategorySelectionView()
        .environmentObject(viewModel)
}

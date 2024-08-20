//
//  CategoriesSelectionViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import Foundation

class CategoriesSelectionViewModel: ObservableObject {
    @Published var categories: [CDCategory] = []

    @Published var isPresented: Bool = false
    @Published var searchText: String = ""

    var filteredCategories: [CDCategory] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    func getCDCategories() {
        let fetchRequest = CDCategory.fetchRequest()

        do {
            self.categories = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func createCategory(_ name: String) {
        let cdCategory = CDCategory(context: PersistentStore.shared.context)
        cdCategory.id = UUID()
        cdCategory.name = name

        saveAndFetchCategories()
    }

    private func saveAndFetchCategories() {
        PersistentStore.shared.save()
        getCDCategories()
    }
}

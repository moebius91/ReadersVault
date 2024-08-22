//
//  NewListEditViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 21.08.24.
//

import Foundation

class NewListEditViewModel: ObservableObject {
    @Published var category: CDCategory?
    @Published var categories: [CDCategory] = []

    func getCDCategories() {
        let fetchRequest = CDCategory.fetchRequest()

        do {
            self.categories = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func createList(_ title: String) {
        let cdList = CDList(context: PersistentStore.shared.context)
        cdList.id = UUID()
        cdList.title = title

        if let newCategory = self.category {
            cdList.updateCategory(newCategory: newCategory)
//            cdList.category = newCategory
            newCategory.list = cdList
        }

        PersistentStore.shared.save()
    }
}

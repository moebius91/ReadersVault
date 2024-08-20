//
//  VaultListViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import Foundation

class VaultListViewModel: ObservableObject {
    @Published var vault: CDVault?
    @Published var vaults: [CDVault] = []

    @Published var selectedBooks: Set<CDBook> = []
    @Published var selectedNotes: Set<CDNote> = []
    @Published var selectedTags: Set<CDTag> = []
    @Published var selectedCategories: Set<CDCategory> = []

    @Published var isPresented: Bool = false

    func createVault(name: String) {
        let cdVault = CDVault(context: PersistentStore.shared.context)
        cdVault.id = UUID()
        cdVault.name = name
        selectedBooks.forEach { book in
            cdVault.addToBooks(book)
            book.addToVaults(cdVault)
        }
        selectedTags.forEach { tag in
            cdVault.addToTags(tag)
            tag.addToVaults(cdVault)
        }
        selectedCategories.forEach { category in
            cdVault.addToCategories(category)
            category.addToVaults(cdVault)
        }

        saveAndFetchVaults()
    }

    func getCDVaults() {
        let fetchRequest = CDVault.fetchRequest()

        do {
            self.vaults = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func deleteVault(_ vault: CDVault) {
        PersistentStore.shared.context.delete(vault)
        saveAndFetchVaults()
    }

    private func saveAndFetchVaults() {
        PersistentStore.shared.save()
        getCDVaults()
    }
}

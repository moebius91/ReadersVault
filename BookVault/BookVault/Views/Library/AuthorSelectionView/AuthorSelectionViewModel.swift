//
//  AuthorSelectionViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import Foundation

class AuthorSelectionViewModel: ObservableObject {
    @Published var authors: [CDAuthor] = []

    @Published var isPresented: Bool = false
    @Published var searchText: String = ""

    var filteredAuthors: [CDAuthor] {
        if searchText.isEmpty {
            return authors
        } else {
            return authors.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    func getCDAuthors() {
        let fetchRequest = CDAuthor.fetchRequest()

        do {
            self.authors = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func createAuthor(_ name: String) {
        let cdAuthor = CDAuthor(context: PersistentStore.shared.context)
        cdAuthor.id = UUID()
        cdAuthor.name = name

        saveAndFetchAuthors()
    }

    private func saveAndFetchAuthors() {
        PersistentStore.shared.save()
        getCDAuthors()
    }
}

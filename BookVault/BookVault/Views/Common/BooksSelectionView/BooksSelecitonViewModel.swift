//
//  BooksSelecitonViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import Foundation

class BooksSelecitonViewModel: ObservableObject {
    @Published var books: [CDBook] = []

    @Published var isPresented: Bool = false
    @Published var searchText: String = ""

    var filteredBooks: [CDBook] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    func getCDBooks() {
        let fetchRequest = CDBook.fetchRequest()

        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
}

//
//  BookListAddBookViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 27.07.24.
//

import Foundation

class BookListAddBookViewModel: ObservableObject {
    @Published var books: [CDBook] = []

    @Published var selectedBooks: Set<CDBook> = []
    @Published var searchText: String = ""

    var filteredBooks: [CDBook] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    func addSelectedBooksToList(_ list: CDList) {
        removeAllBooksFromList(list)

        selectedBooks.forEach { book in
            list.addToBooks(book)
            book.addToLists(list)
        }

        do {
            try PersistentStore.shared.context.save()
            selectedBooks.removeAll()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func getCDBooks() {
        let fetchRequest = CDBook.fetchRequest()

        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch books: \(error)")
        }
    }

    func saveBooksFromList(_ list: CDList) {
        list.books?.forEach { book in
            selectedBooks.insert(book as! CDBook)
        }
    }

    func getBooksByList(_ list: CDList) {
        self.books = list.books?.allObjects as? [CDBook] ?? []
    }
    
    private func removeAllBooksFromList(_ list: CDList) {
        guard let books = list.books?.allObjects as? [CDBook] else {
            return
        }

        for book in books {
            list.removeFromBooks(book)
            book.removeFromLists(list)
        }

        do {
            try PersistentStore.shared.context.save()
        } catch {
            print("Fehler beim Speichern des Contextx: \(error)")
        }
    }
}

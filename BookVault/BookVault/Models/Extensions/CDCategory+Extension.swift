//
//  CDCategory+Extension.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 21.08.24.
//

import Foundation

extension CDCategory {
    func getAllBooks() -> [CDBook]? {
        return self.books?.allObjects as? [CDBook]
    }

    func addBook(_ book: CDBook) {
        self.willChangeValue(forKey: "books")
        self.addToBooks(book)
        self.didChangeValue(forKey: "books")

        self.updateListWithBooks()
    }

    private func updateListWithBooks() {
        guard let list = self.list else {
            print("Keine Liste mit dieser Kategorie verknüpft.")
            return
        }

        if let books = self.getAllBooks() {
            for book in books {
                list.addToBooks(book)
            }
        }
    }
}

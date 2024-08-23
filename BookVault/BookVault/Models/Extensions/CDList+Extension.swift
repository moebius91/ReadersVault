//
//  CDList+Extension.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 21.08.24.
//

import Foundation

extension CDList {
    func addBooksFromCategory() {
        guard let category = self.category else {
            print("Keine Kategorie mit dieser Liste verknüpft.")
            return
        }

        if let books = category.getAllBooks() {
            for book in books {
                self.addToBooks(book)
            }
        }
    }

    func updateCategory(newCategory: CDCategory?) {
        if let oldCategory = self.category {
            if let oldBooks = oldCategory.getAllBooks() {
                for book in oldBooks {
                    self.removeFromBooks(book)
                }
            }
        }

        self.category = newCategory

        addBooksFromCategory()
    }
}

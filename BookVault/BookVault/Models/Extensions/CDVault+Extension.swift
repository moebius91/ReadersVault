//
//  CDVault+Extension.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.08.24.
//

import CoreData

extension CDVault {
    func getAllNotes() -> [CDNote] {
        var allNotes: Set<CDNote> = []

        allNotes.formUnion(self.notes as? Set<CDNote> ?? [])

        for book in self.books as? Set<CDBook> ?? [] {
            allNotes.formUnion(book.notes as? Set<CDNote> ?? [])
        }

        for tag in self.tags as? Set<CDTag> ?? [] {
            allNotes.formUnion(tag.notes as? Set<CDNote> ?? [])
        }

        for category in self.categories as? Set<CDCategory> ?? [] {
            allNotes.formUnion(category.notes as? Set<CDNote> ?? [])
        }

        return Array(allNotes)
    }

    func getAllBooks() -> [CDBook] {
        var allBooks: Set<CDBook> = []

        allBooks.formUnion(self.books as? Set<CDBook> ?? [])

        for tag in self.tags as? Set<CDTag> ?? [] {
            allBooks.formUnion(tag.books as? Set<CDBook> ?? [])
        }

        for category in self.categories as? Set<CDCategory> ?? [] {
            allBooks.formUnion(category.books as? Set<CDBook> ?? [])
        }

        for note in self.notes as? Set<CDNote> ?? [] {
            if let book = note.book {
                allBooks.insert(book)
            }
        }

        return Array(allBooks)
    }
}

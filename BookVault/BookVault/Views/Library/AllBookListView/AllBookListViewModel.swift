//
//  AllBookListViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import Foundation
import SwiftUI
import PhotosUI

class AllBookListViewModel: ObservableObject {
    @Published var book: CDBook?
    @Published var books: [CDBook]

    @Published var coverImage: Data?
    @Published var isbn: String = ""
    @Published var isbn10: String = ""
    @Published var isbn13: String = ""
    @Published var publisher: String = ""
    @Published var shortDescription: String = ""
    @Published var title: String = ""
    @Published var titleLong: String = ""

    @Published var isFavorite: Bool = false
    @Published var isOwned: Bool = false
    @Published var isLoaned: Bool = false
    @Published var isRead: Bool = false
    @Published var authors: [String] = []

    @Published var isSheetShown = false
    @Published var photosPickerItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?

    @Published var selectedAuthors: Set<CDAuthor> = []
    @Published var selectedCategories: Set<CDCategory> = []
    @Published var selectedTags: Set<CDTag> = []

    init(books: [CDBook]) {
        self.books = books
    }

    func saveBookInCoreData() {
        let cdBook = CDBook(context: PersistentStore.shared.context)
        cdBook.id = UUID()
        cdBook.title = self.title
        cdBook.title_long = self.titleLong
        cdBook.isbn = self.isbn
        cdBook.isbn10 = self.isbn10
        cdBook.isbn13 = self.isbn13
        cdBook.publisher = self.publisher
        cdBook.isFavorite = self.isFavorite
        cdBook.isOwned = self.isOwned
        cdBook.isLoaned = self.isLoaned
        cdBook.isRead = self.isRead
        cdBook.createdAt = Date()

        // Autoren müssen anders erfasst werden.
        self.selectedAuthors.forEach { author in
            if let author = checkAndCreateAuthor(author.name ?? "") {
                cdBook.addToAuthors(author)
                author.addToBooks(cdBook)
            }
        }

        if self.photosPickerItem != nil {
            self.photosPickerItem?.loadTransferable(type: Data.self) { result in
                if let data = try? result.get() {
                    cdBook.coverImage = data

                    self.saveAndFetchBooks()
                } else {
                    self.saveAndFetchBooks()
                }
            }
        } else {
            saveAndFetchBooks()
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

    func deleteBook(_ book: CDBook) {
        PersistentStore.shared.context.delete(book)

        saveAndFetchBooks()
    }

    private func saveAndFetchBooks() {
        PersistentStore.shared.save()
        self.getCDBooks()
    }

    // Hilfsfunktionen
    func clear() {
        self.book = nil
        self.coverImage = nil
        self.isbn = ""
        self.isbn10 = ""
        self.isbn13 = ""
        self.publisher = ""
        self.shortDescription = ""
        self.title = ""
        self.titleLong = ""

        self.isFavorite = false
        self.isOwned = false
        self.isLoaned = false
        self.isRead = false
        self.authors = []

        self.isSheetShown = false
        self.photosPickerItem = nil
        self.selectedImage = nil

        self.selectedAuthors = []
        self.selectedCategories = []
        self.selectedTags = []
    }

    private func checkAndCreateAuthor(_ name: String) -> CDAuthor? {
        let fetchRequest = CDAuthor.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        do {
            let results = try PersistentStore.shared.context.fetch(fetchRequest)
            if let existingAuthor = results.first {
                return existingAuthor
            } else {
                let newAuthor = CDAuthor(context: PersistentStore.shared.context)
                newAuthor.id = UUID()
                newAuthor.name = name

                PersistentStore.shared.save()
                return newAuthor
            }
        } catch {
            return nil
        }
    }
}

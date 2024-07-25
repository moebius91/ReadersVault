//
//  BookDetailViewModel.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 19.07.24.
//

import Foundation
import PhotosUI
import SwiftUI

class BookDetailViewModel: ObservableObject {
    @Published var book: CDBook

    @Published var coverUrl: URL
    @Published var coverImage: Data?
    @Published var isbn: String
    @Published var isbn10: String
    @Published var isbn13: String
    @Published var isFavorite: Bool
    @Published var isOwned: Bool
    @Published var isLoaned: Bool
    @Published var publisher: String
    @Published var shortDescription: String
    @Published var title: String
    @Published var titleLong: String

    @Published var isSheetShown = false
    @Published var photosPickerItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?

    @Published var tags: [CDTag] = []
    @Published var categories: [CDCategory] = []
    @Published var notes: [CDNote] = []

    init(book: CDBook) {
        self.book = book
        self.coverUrl = book.coverUrl ?? URL(string: "https://example.com")!
        self.coverImage = book.coverImage
        self.isbn = book.isbn ?? ""
        self.isbn10 = book.isbn10 ?? ""
        self.isbn13 = book.isbn13 ?? ""
        self.isFavorite = book.isFavorite
        self.isOwned = book.isOwned
        self.isLoaned = book.isLoaned
        self.publisher = book.publisher ?? ""
        self.shortDescription = book.short_description ?? ""
        self.title = book.title ?? ""
        self.titleLong = book.title_long ?? ""

        self.getNotesTagsAndCategoriesForBook()
    }

    func getBookFromDB() {
        let fetchRequest = CDBook.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id = %@", book.id! as any CVarArg)

        do {
            self.book = try PersistentStore.shared.context.fetch(fetchRequest).first!
        } catch {
            return
        }
    }

    func getNotesTagsAndCategoriesForBook() {
        getTagsForBook()
        getCategoriesForBook()
        getNotesForBook()
    }

    func getTagsForBook() {
        guard let bookId = self.book.id else { return }

        let fetchRequest = CDTag.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "SUBQUERY(books, $book, $book.id == %@).@count > 0", bookId.uuidString)

        do {
            self.tags = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func getCategoriesForBook() {
        guard let bookId = self.book.id else { return }

        let fetchRequest = CDCategory.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "SUBQUERY(books, $book, $book.id == %@).@count > 0", bookId.uuidString)

        do {
            self.categories = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func getNotesForBook() {
        guard let bookId = self.book.id else { return }

        let fetchRequest = CDNote.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "book.id == %@", bookId.uuidString)

        do {
            self.notes = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func updateCDBook() {
        book.title = self.title
        book.title_long = self.titleLong
        book.isbn = self.isbn
        book.isbn10 = self.isbn10
        book.isbn13 = self.isbn13
        book.isFavorite = self.isFavorite
        book.isOwned = self.isOwned
        book.isLoaned = self.isLoaned
        book.publisher = self.publisher
        book.short_description = self.shortDescription
        book.coverUrl = self.coverUrl

        if self.photosPickerItem != nil {
            self.photosPickerItem?.loadTransferable(type: Data.self) { result in
                if let data = try? result.get() {
                    self.book.coverImage = data

                    PersistentStore.shared.save()
                    self.getBookFromDB()
                } else {
                    PersistentStore.shared.save()
                    self.getBookFromDB()
                }
            }
        } else {
            PersistentStore.shared.save()
            self.getBookFromDB()
        }
    }

    func restoreCoverFromApi() {
        if let imageUrl = book.coverUrl {
            downloadImage(from: imageUrl) { data in
                self.book.coverImage = data
                self.coverImage = data
                self.updateCDBook()
            }
        }
    }

    func deleteBook(_ book: CDBook) {
        PersistentStore.shared.context.delete(book)

        PersistentStore.shared.save()
    }

    // Hilfsfunktionen

    private func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        .resume()
    }
}

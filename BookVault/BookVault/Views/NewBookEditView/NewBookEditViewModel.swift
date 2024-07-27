//
//  NewBookEditViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 26.07.24.
//

import Foundation
import PhotosUI
import SwiftUI

class NewBookEditViewModel: ObservableObject {
    @Published var book: ApiBook

    @Published var coverUrl: URL
    @Published var coverImage: Data?
    @Published var isbn: String
    @Published var isbn10: String
    @Published var isbn13: String
    @Published var publisher: String
    @Published var shortDescription: String
    @Published var title: String
    @Published var titleLong: String

    @Published var isFavorite: Bool = false
    @Published var isOwned: Bool = false
    @Published var isLoaned: Bool = false
    @Published var authors: [String] = []

    @Published var isSheetShown = false
    @Published var photosPickerItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?

    @Published var tags: [CDTag] = []
    @Published var categories: [CDCategory] = []

    init(book: ApiBook) {
        self.book = book
        self.coverUrl = book.image ?? URL(string: "https://example.com")!
        self.isbn = book.isbn
        self.isbn10 = book.isbn10 ?? ""
        self.isbn13 = book.isbn13
        self.publisher = book.publisher ?? ""
        self.shortDescription = book.synopsis ?? ""
        self.title = book.title
        self.titleLong = book.title_long ?? ""

        book.authors?.forEach { author in
            self.authors.append(author)
        }

        if let imageUrl = book.image {
            downloadImage(from: imageUrl) { data in
                self.coverImage = data
            }
        }
    }

    func saveBookInCoreData() {
        let cdBook = CDBook(context: PersistentStore.shared.context)
        cdBook.id = UUID()
        cdBook.title = self.title
        cdBook.coverUrl = self.coverUrl
        cdBook.isbn = self.isbn
        cdBook.isbn10 = self.isbn10
        cdBook.isbn13 = self.isbn13
        cdBook.publisher = self.publisher
        cdBook.isFavorite = self.isFavorite
        cdBook.isOwned = self.isOwned
        cdBook.isLoaned = self.isLoaned

        self.authors.forEach { name in
            if let author = checkAndCreateAuthor(name) {
                cdBook.addToAuthors(author)
                author.addToBooks(cdBook)
            }
        }

        if let imageUrl = book.image {
            downloadImage(from: imageUrl) { data in
                cdBook.coverImage = data
                PersistentStore.shared.save()
            }
        } else {
            PersistentStore.shared.save()
        }

    }

    func restoreCoverFromApi() {
        if let imageUrl = book.image {
            downloadImage(from: imageUrl) { data in
                self.coverImage = data
            }
        }
    }

    // Hilfsfunktionen
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

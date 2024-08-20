//
//  BookDetailViewModel.swift
//  ReadersVault
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
    @Published var isRead: Bool
    @Published var publisher: String
    @Published var shortDescription: String
    @Published var title: String
    @Published var titleLong: String

    @Published var isEditSheetShown = false
    @Published var isSyncSheetShown = false
    @Published var isListSheetShown = false
    @Published var isAlertShown = false
    @Published var photosPickerItem: PhotosPickerItem?
    @Published var selectedImage: UIImage?

    @Published var tags: [CDTag] = []
    @Published var categories: [CDCategory] = []
    @Published var notes: [CDNote] = []
    @Published var lists: [CDList] = []

    @Published var allLists: [CDList] = []

    var filteredLists: [CDList] {
        var filteredLists: Set<CDList> = []
        allLists.forEach { list in
            if !lists.contains(list) {
                filteredLists.insert(list)
            }
        }
        return Array(filteredLists)
    }

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
        self.isRead = book.isRead
        self.publisher = book.publisher ?? ""
        self.shortDescription = book.short_description ?? ""
        self.title = book.title ?? ""
        self.titleLong = book.title_long ?? ""

        self.getNotesListsTagsAndCategoriesForBook()
    }

    func getAllLists() {
        let fetchRequest = CDList.fetchRequest()

        do {
            self.allLists = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
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

    func getNotesListsTagsAndCategoriesForBook() {
        getNotesForBook()
        getListsForBook()
        getTagsForBook()
        getCategoriesForBook()
    }

    func getTagsForBook() {
        self.tags = self.book.tags?.allObjects as? [CDTag] ?? []
    }

    func getCategoriesForBook() {
        self.categories = self.book.categories?.allObjects as? [CDCategory] ?? []
    }

    func getNotesForBook() {
        self.notes = self.book.notes?.allObjects as? [CDNote] ?? []
    }

    func getListsForBook() {
        self.lists = self.book.lists?.allObjects as? [CDList] ?? []
    }

    func addBookToList(_ list: CDList) {
        list.addToBooks(self.book)
        self.book.addToLists(list)

        PersistentStore.shared.save()
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
        book.isRead = self.isRead
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

    func removeBookFromList(_ list: CDList) {
        list.removeFromBooks(self.book)
        self.book.removeFromLists(list)
        PersistentStore.shared.save()
        getListsForBook()
    }

    func removeTag(_ tag: CDTag) {
        tag.removeFromBooks(self.book)
        self.book.removeFromTags(tag)
        PersistentStore.shared.save()
        getTagsForBook()
    }

    func removeCategory(_ category: CDCategory) {
        category.removeFromBooks(self.book)
        self.book.removeFromCategories(category)
        PersistentStore.shared.save()
        getCategoriesForBook()
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

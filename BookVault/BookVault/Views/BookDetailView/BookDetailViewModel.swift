//
//  BookDetailViewModel.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 19.07.24.
//

import Foundation

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
        
        PersistentStore.shared.save()
        self.getBookFromDB()
    }
    
    func deleteBook(_ book: CDBook) {
        PersistentStore.shared.context.delete(book)
        
        PersistentStore.shared.save()
        self.getBookFromDB()
    }
}

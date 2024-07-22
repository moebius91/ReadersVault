//
//  LibraryViewModel.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 12.07.24.
//

import Foundation

class LibraryViewModel: ObservableObject {
    @Published var book: CDBook?
    @Published var books: [CDBook] = []
    
    @Published var list: CDList?
    @Published var lists: [CDList] = []
    
    @Published var presentNewListSheet: Bool = false
    @Published var showingAlert: Bool = false
    
    func saveBook(_ book: CDBook) {
        self.book = book
    }
    
    func saveList(_ list: CDList) {
        self.list = list
    }
    
    func getCDBooks() {
        let fetchRequest = CDBook.fetchRequest()
        
        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func getOwnCDBooks() {
        let fetchRequest = CDBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isOwned = %@ OR (isOwned = %@ AND isLoaned = %@)", NSNumber(value: true), NSNumber(value: false), NSNumber(value: true))
        
        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func getBorrowedCDBooks() {
        let fetchRequest = CDBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isOwned = %@ AND isLoaned = %@", NSNumber(value: false), NSNumber(value: true))
        
        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func getLentCDBooks() {
        let fetchRequest = CDBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "isOwned = %@ AND isLoaned = %@", NSNumber(value: true), NSNumber(value: true))
        
        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func getCDLists() {
        let fetchRequest = CDList.fetchRequest()
        
        do {
            self.lists = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func getBooksByList(_ list: CDList) {
        let fetchRequest = CDBook.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", list.title ?? "no title")
        
        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
    
    func updateBookFavorite(_ book: CDBook) {
        book.isFavorite.toggle()
        
        saveAndFetchBooks()
    }
    
    func updateBookIsOwned(_ book: CDBook) {
        book.isOwned.toggle()
        
        saveAndFetchBooks()
    }
    
    func updateBookIsLoaned(_ book: CDBook) {
        book.isLoaned.toggle()
        
        saveAndFetchBooks()
    }
    
    func deleteBook(_ book: CDBook) {
        PersistentStore.shared.context.delete(book)
        
        saveAndFetchBooks()
    }
    
    private func saveAndFetchBooks() {
        PersistentStore.shared.save()
        self.getCDBooks()
    }
    
    // Listen
    
    func createList(_ title: String) {
        let cdList = CDList(context: PersistentStore.shared.context)
        cdList.id = UUID()
        cdList.title = title
        
        saveAndFetchLists()
    }
    
    func addBooksToList(_ list: CDList, books: [CDBook]) {
        books.forEach { book in
            list.addToBooks(book)
        }
        
        saveAndFetchLists()
    }
    
    func deleteList(_ list: CDList) {
        PersistentStore.shared.context.delete(list)
        
        saveAndFetchLists()
    }
    
    private func saveAndFetchLists() {
        PersistentStore.shared.save()
        self.getCDLists()
    }
}

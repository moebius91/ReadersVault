//
//  SearchViewModel.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 08.07.24.
//

import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var book: ApiBook?
    @Published var books: [ApiBook] = []
    @Published var authors: [String] = []
    
    private let repository: ApiRepository = ApiRepository.shared
    
    func saveBook(_ book: ApiBook) {
        self.book = book
    }
    
    func getBookByIsbn(_ isbn: String) {
        Task {
            do {
                self.book = try await self.repository.getBookByIsbn(isbn: isbn)
            } catch {
                print(error)
            }
        }
    }
    
    func getAuthors(_ name: String) {
        Task {
            do {
                self.authors = try await self.repository.getAuthors(name: name)
            } catch {
                print(error)
            }
        }
    }
    
    func getBooksByAuthor(_ name: String) {
        Task {
            do {
                self.books = try await self.repository.getBooksByAuthor(name)
            } catch {
                print(error)
            }
        }
    }
    
    func getBooksByTitle(_ title: String) {
        Task {
            do {
                self.books = try await self.repository.getBooksByTitle(title: title)
            } catch {
                print(error)
            }
        }
    }
    
    func saveBookInCoreData() {
        let cdBook = CDBook(context: PersistentStore.shared.context)
        cdBook.id = UUID()
        cdBook.title = self.book?.title
        
        self.book?.authors?.forEach { name in
            if let author = checkAndCreateAuthor(name) {
                cdBook.addToAuthors(author)
                author.addToBooks(cdBook)
            }
        }
        
        PersistentStore.shared.save()
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
}

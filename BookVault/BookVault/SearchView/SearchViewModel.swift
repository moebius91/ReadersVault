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
    
    func getBookByIsbn(_ isbn: String) {
        Task {
            do {
                self.book = try await self.repository.getBookByIsbn(isbn: isbn)
            } catch {
                print(error)
            }
        }
    }
    
    func getAuthors(_ author: String) {
        Task {
            do {
                self.authors = try await self.repository.getAuthors(author: author)
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
}

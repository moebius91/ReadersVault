//
//  HomeAddedLastBooksViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 27.08.24.
//

import Foundation

class HomeAddedLastBooksViewModel: ObservableObject {
    @Published var books: [CDBook] = []

    func getLastAddedBooks() {
        let fetchRequest = CDBook.fetchRequest()

        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest).sorted(by: { $0.createdAt ?? Date() > $1.createdAt ?? Date() })
        } catch {
            return
        }
    }
}

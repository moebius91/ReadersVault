//
//  HomeFavListViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 26.08.24.
//

import Foundation

class HomeFavListViewModel: ObservableObject {
    @Published var books: [CDBook] = []

    func getAllFavoriteBooks() {
        let fetchRequest = CDBook.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")

        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
}

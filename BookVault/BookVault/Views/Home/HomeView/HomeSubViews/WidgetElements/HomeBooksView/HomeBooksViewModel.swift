//
//  HomeBooksViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 24.08.24.
//

import Foundation

class HomeBooksViewModel: ObservableObject {
    func getCDBookForWidgetBook(_ book: WidgetBook) -> CDBook? {
        let fetchRequest = CDBook.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %@", book.cdBookId.uuidString)

        do {
            if let cdBook = try PersistentStore.shared.context.fetch(fetchRequest).first {
                return cdBook
            }
        } catch {
            return nil
        }
        return nil
    }
}

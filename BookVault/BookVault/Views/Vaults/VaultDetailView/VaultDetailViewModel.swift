//
//  VaultDetailViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.08.24.
//

import Foundation

class VaultDetailViewModel: ObservableObject {
    @Published var books: Set<CDBook> = []
    @Published var notes: Set<CDNote> = []
    @Published var vault: CDVault

    init(vault: CDVault) {
        self.vault = vault
        self.getAllBooksInVault()
        self.getAllNotesInVault()
    }

    func getAllBooksInVault() {
        let allBooks = vault.getAllBooks()
        self.books = Set(allBooks)
    }

    func getAllNotesInVault() {
        let allNotes = vault.getAllNotes()
        self.notes = Set(allNotes)
    }
}

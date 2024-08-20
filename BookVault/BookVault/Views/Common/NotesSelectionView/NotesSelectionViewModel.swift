//
//  NotesSelectionViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import Foundation

class NotesSelectionViewModel: ObservableObject {
    @Published var notes: [CDNote] = []

    @Published var isPresented: Bool = false
    @Published var searchText: String = ""

    var filteredNotes: [CDNote] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    func getCDNotes() {
        let fetchRequest = CDNote.fetchRequest()

        do {
            self.notes = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
}

//
//  NotesListViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import Foundation

class NotesListViewModel: ObservableObject {
    @Published var note: CDNote = CDNote()

    @Published var notes: [CDNote] = []
    @Published var books: [CDBook] = []

    @Published var isPresented: Bool = false
    @Published var book: CDBook?

    @Published var selectedTags: Set<CDTag> = []
    @Published var selectedCategories: Set<CDCategory> = []
    @Published var searchText: String = ""

    @Published var editTitle = ""
    @Published var editContent = ""

    func createNote(title: String, content: String) {
        let cdNote = CDNote(context: PersistentStore.shared.context)
        cdNote.id = UUID()
        cdNote.title = title
        cdNote.content = content
        cdNote.createdAt = Date()
        cdNote.book = self.book

        selectedTags.forEach { tag in
            cdNote.addToTags(tag)
            tag.addToNotes(cdNote)
        }

        selectedCategories.forEach { category in
            cdNote.addToCategories(category)
            category.addToNotes(cdNote)
        }

        saveAndFetchNotes()
    }

    func getCDNotes() {
        let fetchRequest = CDNote.fetchRequest()

        do {
            self.notes = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func updateNote() {
        note.title = self.editTitle
        note.content = self.editContent

        PersistentStore.shared.save()

        self.editTitle = ""
        self.editContent = ""
    }

    func deleteCDNotes(_ note: CDNote) {
        PersistentStore.shared.context.delete(note)

        saveAndFetchNotes()
    }

    private func saveAndFetchNotes() {
        PersistentStore.shared.save()
        getCDNotes()
    }

    // Books
    func getCDBooks() {
        let fetchRequest = CDBook.fetchRequest()

        do {
            self.books = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }
}

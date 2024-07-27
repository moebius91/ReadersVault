//
//  NotesListViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import Foundation

class NotesListViewModel: ObservableObject {
    @Published var tags: [CDTag] = []
    @Published var categories: [CDCategory] = []
    @Published var notes: [CDNote] = []
    @Published var books: [CDBook] = []

    @Published var isPresented: Bool = false
    @Published var book: CDBook?

    @Published var selectedTags: Set<CDTag> = []
    @Published var selectedCategories: Set<CDCategory> = []
    @Published var searchText: String = ""

    var filteredTags: [CDTag] {
        if searchText.isEmpty {
            return tags
        } else {
            return tags.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    var filteredCategories: [CDCategory] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

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

    func deleteCDNotes(_ note: CDNote) {
        PersistentStore.shared.context.delete(note)

        saveAndFetchNotes()
    }

    private func saveAndFetchNotes() {
        PersistentStore.shared.save()
        getCDNotes()
    }

    // Tags
    func getCDTags() {
        let fetchRequest = CDTag.fetchRequest()

        do {
            self.tags = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func createTag(_ name: String) {
        let cdTag = CDTag(context: PersistentStore.shared.context)
        cdTag.id = UUID()
        cdTag.name = name

        saveAndFetchTags()
    }

    private func saveAndFetchTags() {
        PersistentStore.shared.save()
        getCDTags()
    }

    // Categories

    func getCDCategories() {
        let fetchRequest = CDCategory.fetchRequest()

        do {
            self.categories = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func createCategory(_ name: String) {
        let cdCategory = CDCategory(context: PersistentStore.shared.context)
        cdCategory.id = UUID()
        cdCategory.name = name

        saveAndFetchCategories()
    }

    private func saveAndFetchCategories() {
        PersistentStore.shared.save()
        getCDCategories()
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

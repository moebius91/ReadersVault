//
//  BookListViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 11.07.24.
//

import Foundation

class BookListDetailViewModel: ObservableObject {
    @Published var book: CDBook?
    @Published var books: [CDBook] = []

    @Published var list: CDList?
    @Published var lists: [CDList] = []

    @Published var category: CDCategory?
    @Published var categories: [CDCategory] = []

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

    func getCDCategories() {
        let fetchRequest = CDCategory.fetchRequest()

        do {
            self.categories = try PersistentStore.shared.context.fetch(fetchRequest)
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
        self.books = list.books?.allObjects as? [CDBook] ?? []
    }

    func updateBookFavorite(_ book: CDBook) {
        book.isFavorite.toggle()

        saveAndFetchBooks()
    }

    func deleteBookFromList(_ list: CDList, book: CDBook) {
        list.removeFromBooks(book)

        PersistentStore.shared.save()
        getBooksByList(list)
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

    func updateList(_ list: CDList, title: String, category: CDCategory) {
        list.title = title
        list.category = category
        category.list = list

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

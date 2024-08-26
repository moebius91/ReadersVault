//
//  HomeViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var widget: Widget?
    @Published var widgets: [Widget] = [] {
        didSet {
            saveWidgets()
        }
    }

    @Published var books: [WidgetBook] = []
    @Published var cdBooks: [CDBook] = []

    @Published var firstBook: CDBook?
    @Published var secondBook: CDBook?

    var filteredFirstBook: [CDBook] {
        if secondBook == nil {
            return cdBooks
        } else {
            return cdBooks.filter { $0.isbn13 != secondBook?.isbn13 }
        }
    }

    var filteredSecondBook: [CDBook] {
        if firstBook == nil {
            return cdBooks
        } else {
            return cdBooks.filter { $0.isbn13 != firstBook?.isbn13 }
        }
    }

    @Published var selectedWidgets: [Widget] = []
    @Published var selectedWidgetElements: [WidgetElement] = []

    @Published var draggingWidget: Widget?
    @Published var draggingWidgetElement: WidgetElement?

    @Published var areWidgetsDragable: Bool = false
    @Published var isSheetPresented: Bool = false

    private let widgetsKey = "widgets"

    init() {
        loadWidgets()
    }

    func getCDBooks() {
        let fetchRequest = CDBook.fetchRequest()

        do {
            self.cdBooks = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func cdBooksToWidgetBooks() {
        let libraryViewModel = LibraryViewModel()
        libraryViewModel.getCDBooks()

        libraryViewModel.books.forEach { book in
            if let title = book.title {
                let newBook = WidgetBook(cdBookId: UUID(), title: title, cover: book.coverImage)
                books.append(newBook)
            }
        }
    }

    func toggleWidgetItemsMovable(for widgetId: UUID) {
        if let index = widgets.firstIndex(where: { $0.id == widgetId }) {
            widgets[index].itemsMovable.toggle()
        }
    }

    func addWidget(_ widget: Widget) {
        widgets.append(widget)
    }

    func addAllSelectedWidgets() {
        widgets.removeAll()
        selectedWidgets.forEach { widget in
            self.widgets.append(widget)
        }
    }

    func addAllWidgetsToSelected() {
        selectedWidgets.removeAll()
        widgets.forEach { widget in
            self.selectedWidgets.append(widget)
        }
    }

    func removeWidgetFromById(_ id: UUID) {
        widgets.removeAll(where: { $0.id == id })
    }

    func removeWidgetFromSelectedById(_ id: UUID) {
        selectedWidgets.removeAll(where: { $0.id == id })
    }

    func clearSelectedWidgets() {
        selectedWidgets.removeAll()
    }

    func addAllElementsFromWidgetToSelected(_ widget: Widget) {
        selectedWidgetElements.removeAll()
        widget.elements.forEach { element in
            selectedWidgetElements.append(element)
        }
    }

    func addAllSelectedElementsToWidget(_ widget: Widget) {
        var elements: [WidgetElement] = []

        widgets.removeAll(where: { $0.id == widget.id})

        selectedWidgetElements.forEach { element in
            elements.append(element)
        }

        let newWidget = Widget(id: widget.id, title: widget.title, elements: elements)

        addWidget(newWidget)
    }

    // MARK: Funktionen zum Widgets bauen
    func createWidget(title: String, elements: [WidgetElement]) -> Widget {
        return Widget(title: title, elements: elements)
    }

    func createStatisticWidget(title: String, elements: [WidgetElement]) -> Widget {
        return Widget(title: title, elements: [WidgetElement(name: "Statistik", type: .stats, stats: ["Anzahl Bücher": "999"])])
    }

    func createBookWidget(title: String, numberOfBooks: Int, books: (CDBook, CDBook?)) -> Widget {
        let firstWidgetBook = WidgetBook(cdBookId: books.0.id ?? UUID(), title: books.0.title ?? "", cover: books.0.coverImage)
        let secondWidgetBook = WidgetBook(cdBookId: books.1?.id ?? UUID(), title: books.1?.title ?? "", cover: books.1?.coverImage)
        if numberOfBooks == 1 {
            return Widget(title: title, elements: [WidgetElement(name: "Bücher", type: .book, book: firstWidgetBook)])
        } else {
            return Widget(title: title, elements: [WidgetElement(name: "Bücher", type: .books, books: [firstWidgetBook, secondWidgetBook])])
        }
    }

    func createListWidget(title: String, elements: [WidgetElement]) -> Widget {
        return Widget(title: title, elements: elements)
    }

    func createNoteWidget(title: String, elements: [WidgetElement]) -> Widget {
        return Widget(title: title, elements: elements)
    }

    private func createDoubleBookWidgetElement(name: String, firstBook: WidgetBook, secondBook: WidgetBook) -> WidgetElement {
        return WidgetElement(name: name, type: .books, books: [firstBook, secondBook])
    }
    // MARK: ENDE Funktionen zum Widgets bauen

    private func saveWidgets() {
        if let encoded = try? JSONEncoder().encode(widgets) {
            UserDefaults.standard.set(encoded, forKey: widgetsKey)
        }
    }

    private func loadWidgets() {
        if let savedData = UserDefaults.standard.data(forKey: widgetsKey),
           let decodedWidgets = try? JSONDecoder().decode([Widget].self, from: savedData) {
            widgets = decodedWidgets
        }
    }
}

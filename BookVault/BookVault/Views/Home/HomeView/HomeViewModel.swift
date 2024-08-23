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

    @Published var selectedWidgets: [Widget] = []
    @Published var selectedWidgetElements: [WidgetElement] = []
    @Published var selection = "Red"

    @Published var draggingWidget: Widget?
    @Published var draggingWidgetElement: WidgetElement?

    @Published var areWidgetsDragable: Bool = false
    @Published var isSheetPresented: Bool = false

    private let widgetsKey = "widgets"

    init() {
        loadWidgets()

        // Testfunktion
//        if widgets.isEmpty {
//            self.dummieWidgets()
//        }
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

    // Testfunktion
    private func dummieWidgets() {
        let libraryViewModel = LibraryViewModel()
        libraryViewModel.getCDBooks()

        var elementsOne: [WidgetElement] = []

        if let book = libraryViewModel.books.first {
            if let cover = book.coverImage, let bookId = book.id, let bookTitle = book.title {
                let widgetBook = WidgetBook(cdBookId: bookId, title: bookTitle, cover: cover)

                elementsOne = [
                    WidgetElement(name: "Buch", type: .book, book: widgetBook),
                    WidgetElement(name: "Name", type: .standard),
                    WidgetElement(name: "Name", type: .standard),
                    WidgetElement(name: "Name", type: .standard),
                    WidgetElement(name: "Name", type: .standard)
                ]
            }
        }

        let elements = [
            WidgetElement(name: "Name", type: .standard),
            WidgetElement(name: "Name", type: .standard),
            WidgetElement(name: "Name", type: .standard),
            WidgetElement(name: "Name", type: .standard),
            WidgetElement(name: "Name", type: .standard)
        ]

        let widgetOne = Widget(title: "Erstes Widget", elements: elementsOne)
        let widgetTwo = Widget(title: "Zweites Widget", elements: elements)
        let widgetThree = Widget(title: "Drittes Widget", elements: elements)
        let widgetFour = Widget(title: "Viertes Widget", elements: elements)

        let widgets = [
            widgetOne,
            widgetTwo,
            widgetThree,
            widgetFour
        ]

        self.widgets = widgets
    }
}

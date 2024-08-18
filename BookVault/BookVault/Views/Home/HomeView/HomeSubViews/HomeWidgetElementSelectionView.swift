//
//  HomeWidgetElementSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 17.08.24.
//

import SwiftUI

struct HomeWidgetElementSelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var viewModel: HomeViewModel
    @State private var selection: WidgetElement.ElementType = .standard
    @State private var name: String = ""

    @State private var bookSelection: WidgetBook = WidgetBook(cdBookId: UUID(), title: "")

    @State private var isTitleEdible = false
    @State private var title = ""

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                List {
//                    Section("Titel bearbeiten") {
//                        if let widget = viewModel.widget {
//                            if !isTitleEdible {
//                                Text(widget.title)
//                                    .foregroundStyle(.primary)
//                                    .onTapGesture {
//                                        isTitleEdible.toggle()
//                                    }
//                            }
//                        }
//                    }
                    Section("Vorschau") {
                        HomeElementView(element: WidgetElement(name: name, type: selection))
                    }
                    Section("Neues Element") {
                        Picker("Wähle ein Element", selection: $selection) {
                            ForEach(WidgetElement.ElementType.allCases, id: \.self) { type in
                                Text(type.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        TextField("Elementname", text: $name)
                        if selection == .book {
                            Picker("Buch auswählen", selection: $bookSelection) {
                                ForEach(viewModel.books, id: \.self) { book in
                                    Text(book.title)
                                }
                            }
                        }
                        Button("Element hinzufügen") {
                            var newWidgetElement = WidgetElement(name: name, type: selection)
                            if selection == .book {
                                newWidgetElement = WidgetElement(name: name, type: selection, book: bookSelection)
                            }
                            viewModel.selectedWidgetElements.append(newWidgetElement)

                            if let widget = viewModel.widget, let widgetIndex = viewModel.widgets.firstIndex(where: { $0.id == widget.id}) {
                                viewModel.widgets[widgetIndex].elements.append(newWidgetElement)
                            } else {
                                print("Fehler!")
                            }
                            name = ""
                            selection = .standard
                        }
                    }
                    if !viewModel.selectedWidgetElements.isEmpty {
                        Section("Ausgewählte Elemente") {
                            ForEach(viewModel.selectedWidgetElements) { element in
                                VStack {
                                    Text(element.name)
                                }
                                .swipeActions {
                                    Button(role: .destructive, action: {
                                        viewModel.selectedWidgetElements.removeAll(where: { $0.id == element.id })
                                        if let widget = viewModel.widget {
                                            if  let widgetIndex = viewModel.widgets.firstIndex(where: { $0.id == widget.id }) {
                                                viewModel.widgets[widgetIndex].elements.removeAll(where:  { $0.id == element.id })
                                            }
                                        }
                                    }, label: {
                                        Label("", systemImage: "trash")
                                    })
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Widget bearbeiten")
        }
    }
}

#Preview {
    HomeWidgetElementSelectionView()
        .environmentObject(HomeViewModel())
}

#Preview("HomeView") {
    HomeView()
}

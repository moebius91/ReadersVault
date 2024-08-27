//
//  HomeSettingsSheetView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 17.08.24.
//

import SwiftUI

struct HomeSettingsSheetView: View {
    enum WidgetType: String, CaseIterable, Identifiable {
        case book = "Buch-Widget"
        case statistic = "Statistiken"
        case list = "Listen-Widget"
        case note = "Notizen-Widget"
        case fav = "Favoriten-Widget"
        case addedLast = "Zuletzt-Hinzugefügt"

        var id: String { rawValue }
    }

    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var title = ""
    @State private var selection: WidgetType = .book

    @State private var numberOfBooks: Int = 1

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.systemGray6))
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.isSheetPresented.toggle()
                            }, label: {
                                Label("", systemImage: "xmark")
                            })
                            .padding()
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
                .frame(height: 25)
                List {
                    Section("Widget") {
                        TextField("Widgetname", text: $title)
                        Picker("Widget auswählen", selection: $selection) {
                            ForEach(WidgetType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        switch selection {
                        case .book:
                            Picker("Wie viele Bücher?", selection: $numberOfBooks) {
                                Text("Eins").tag(1)
                                Text("Zwei").tag(2)
                            }
                            Picker("Das erste Buch:", selection: $viewModel.firstBook) {
                                Text("Kein Buch").tag(nil as CDBook?)
                                ForEach(viewModel.filteredFirstBook) { book in
                                    Text(book.title?.truncate(length: 30) ?? "no title").tag(book as CDBook?)
                                }
                            }
                            if numberOfBooks == 2 {
                                Picker("Das zweite Buch:", selection: $viewModel.secondBook) {
                                    Text("Kein Buch").tag(nil as CDBook?)
                                    ForEach(viewModel.filteredSecondBook) { book in
                                        Text(book.title?.truncate(length: 30) ?? "no title").tag(book as CDBook?)
                                    }
                                }
                            }
                        case .list:
                            Text("Test")
                        case .note:
                            Text("Test")
                        case .statistic:
                            Text("Statistiken")
                        case .fav:
                            Text("Favoriten-Widget")
                        case .addedLast:
                            Text("Zuletzt hinzugefügt.")
                        }
                        Button("Widget hinzufügen") {
                            var newWidget = viewModel.createWidget(title: title, elements: [])

                            if !title.isEmpty {
                                switch selection {
                                case .book:
                                    if let firstBook = viewModel.firstBook {
                                        if let secondBook = viewModel.secondBook {
                                            newWidget = viewModel.createBookWidget(title: title, numberOfBooks: numberOfBooks, books: (firstBook, secondBook))
                                        } else {
                                            newWidget = viewModel.createBookWidget(title: title, numberOfBooks: numberOfBooks, books: (firstBook, nil))
                                        }
                                    }
                                case .statistic:
                                    newWidget = newWidget
                                case .list:
                                    newWidget = newWidget
                                case .note:
                                    newWidget = newWidget
                                case .fav:
                                    newWidget = viewModel.createFavoriteWidget(title: title)
                                case .addedLast:
                                    newWidget = viewModel.createAddedLastWidget(title: title)
                                }
                                viewModel.selectedWidgets.append(newWidget)
                                viewModel.widgets.append(newWidget)
                                title = ""
                            }
                        }
                    }
                    if !viewModel.selectedWidgets.isEmpty {
                        Section("Widgets") {
                            ForEach(viewModel.selectedWidgets) { widget in
                                VStack {
                                    Text(widget.title)
                                }
                                .swipeActions {
                                    Button(role: .destructive, action: {
                                        viewModel.removeWidgetFromSelectedById(widget.id)
                                        viewModel.removeWidgetFromById(widget.id)
                                    }, label: {
                                        Label("", systemImage: "trash")
                                    })
                                }
                            }
                        }
                    }
                    Section {
                        Button(action: {
                            viewModel.clearSelectedWidgets()
                            viewModel.isSheetPresented.toggle()
                        }, label: {
                            Text("Schließen")
                        })
                    }
                }
            }
            .onAppear {
                viewModel.getCDBooks()
                viewModel.addAllWidgetsToSelected()
                viewModel.widget = nil
            }
        }
    }
}

#Preview {
    HomeSettingsSheetView()
        .environmentObject(HomeViewModel())
}

#Preview("HomeView") {
    HomeView()
}

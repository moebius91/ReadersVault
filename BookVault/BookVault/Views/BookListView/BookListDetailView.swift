//
//  BookListDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

struct BookListDetailView: View {
    @EnvironmentObject var viewModel: LibraryViewModel

    @State private var isNewPresented: Bool = false
    @State private var isEditPresented: Bool = false
    @State private var isAlertShown: Bool = false

    var body: some View {
        NavigationStack {
            List(viewModel.books) { book in
                NavigationLink(destination: {
                    BookDetailView(viewModel: BookDetailViewModel(book: book))
                }, label: {
                    Text(book.title ?? "no title")
                })
                .swipeActions {
                    Button(role: .destructive, action: {
                        viewModel.deleteBook(book)
                    }) {
                        Image(systemName: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button(action: {
                        viewModel.book = book
                        isEditPresented = true
                    }) {
                        Image(systemName: "pencil")
                            .tint(.blue)
                    }
                }
            }
            .navigationTitle(viewModel.list?.title ?? "Deine Bücher")
            .toolbar {
                Button("", systemImage: "plus") {
                    isNewPresented.toggle()
                }
            }
            .sheet(isPresented: $isEditPresented) {
                if let book = viewModel.book {
                    BookDetailEditView()
                        .environmentObject(BookDetailViewModel(book: book))
                }
            }
            .sheet(isPresented: $isNewPresented) {
                NavigationStack {
                    Form {
                        Section {
                            Text("Folgende Bücher können hinzugefügt werden:")
                            List(viewModel.books) { book in
                                Text(book.title ?? "no title")
                            }
                        }
                        Button("Bücher hinzufügen") {
                            isNewPresented.toggle()
                        }
                    }
                    .onAppear {
                        viewModel.getCDBooks()
                    }
                    .navigationTitle("Bücher hinzufügen")
                }
            }
        }
    }
}

#Preview {
    let viewModel = LibraryViewModel()
    viewModel.getCDBooks()

    let list = CDList(context: PersistentStore.shared.context)
    list.title = "Dies ist ein Titel"

    viewModel.books.forEach { book in
        list.addToBooks(book)
    }

    viewModel.getCDLists()
    viewModel.saveList(list)

    viewModel.getBooksByList(viewModel.lists.first ?? viewModel.list!)

    return BookListDetailView()
        .environmentObject(viewModel)
        .onAppear {
            viewModel.getBooksByList(viewModel.lists.first ?? viewModel.list!)
        }
}

#Preview("LibraryView") {
    LibraryView()
}

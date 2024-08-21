//
//  BookListDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

struct BookListDetailView: View {
    @EnvironmentObject var viewModel: BookListDetailViewModel
    @EnvironmentObject var list: CDList

    @State private var isNewPresented: Bool = false
    @State private var isEditPresented: Bool = false
    @State private var title: String = ""

    var body: some View {
        NavigationStack {
            List(viewModel.books) { book in
                NavigationLink(destination: {
                    BookDetailView(viewModel: BookDetailViewModel(book: book), syncViewModel: BookDetailSyncViewModel(book: book))
                }, label: {
                    Text(book.title ?? "no title")
                })
                .swipeActions {
                    Button(role: .destructive, action: {
                        viewModel.deleteBookFromList(list, book: book)
                    }) {
                        Image(systemName: "trash")
                    }
                }
//                .swipeActions(edge: .leading) {
//                    Button(action: {
//                        viewModel.book = book
//                        isEditPresented = true
//                    }) {
//                        Image(systemName: "pencil")
//                            .tint(.blue)
//                    }
//                }
            }
            .navigationTitle(list.title ?? "no title")
            .toolbar {
                Button("", systemImage: "pencil") {
                    isEditPresented.toggle()
                }
                Button("", systemImage: "plus") {
                    isNewPresented.toggle()
                }
            }
            .sheet(isPresented: $isEditPresented) {
                Form {
                    Section("Titel bearbeiten") {
                        TextField(list.title ?? "no title", text: $title)
                    }
                    Section {
                        Button(action: {
                            viewModel.updateListTitle(list, title)
                            isEditPresented.toggle()
                        }) {
                            Text("Speichern")
                        }
                    }
                }
                .onAppear {
                    title = list.title ?? "no title"
                }
            }
            .sheet(isPresented: $isNewPresented, onDismiss: {
                viewModel.getBooksByList(list)
            }) {
                BookListAddBookView(list: list, isNewPresented: $isNewPresented)
            }
        }
        .onAppear {
            title = list.title ?? "no title"
            viewModel.getBooksByList(list)
        }
        .onDisappear {
            viewModel.list = nil
        }
    }
}

#Preview {
    let viewModel = BookListDetailViewModel()
    viewModel.getCDLists()

    if let list = viewModel.lists.first {
        return BookListDetailView()
            .environmentObject(viewModel)
            .environmentObject(list)
    }

    return VStack {
            Text("Diesen Text solltest Du eigentlich nicht sehen.")
            Text("Ein Fehler ist aufgetreten.")
        }
}

#Preview("LibraryView") {
    LibraryView()
}

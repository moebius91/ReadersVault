//
//  BookListDetailView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

struct BookListDetailView: View {
    @EnvironmentObject var viewModel: LibraryViewModel

    @State private var isPresented: Bool = false

    var body: some View {
        NavigationStack {
            List(viewModel.books) { book in
                Text(book.title ?? "no title")
            }
            .navigationTitle(viewModel.list?.title ?? "Deine Bücher")
            .toolbar {
                Button("", systemImage: "plus") {
                    isPresented.toggle()
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    Form {
                        Section {
                            Text("Folgende Bücher können hinzugefügt werden:")
                            List(viewModel.books) { book in
                                Text(book.title ?? "no title")
                            }
                        }
                        Button("Bücher hinzufügen") {
                            isPresented.toggle()
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

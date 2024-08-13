//
//  AllBookListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 27.07.24.
//

import SwiftUI

struct AllBookListView: View {
    @EnvironmentObject var viewModel: AllBookListViewModel

    @State private var isNewPresented: Bool = false
    @State private var isEditPresented: Bool = false

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
            .navigationTitle("Deine Bücher")
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
            .sheet(isPresented: $isNewPresented, onDismiss: {
                viewModel.getCDBooks()
            }) {
                AllBookListNewBookView(isSheetShown: $isNewPresented)
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()

    let viewModel = AllBookListViewModel(books: libraryViewModel.books)

    return AllBookListView()
        .environmentObject(viewModel)
}

#Preview("LibraryView") {
    LibraryView()
}

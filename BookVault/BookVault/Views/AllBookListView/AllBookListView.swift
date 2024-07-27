//
//  AllBookListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 27.07.24.
//

import SwiftUI

struct AllBookListView: View {
    @EnvironmentObject var viewModel: LibraryViewModel

    @State private var isNewPresented: Bool = false
    @State private var isEditPresented: Bool = false

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
            .navigationTitle("Deine Bücher")
//            .toolbar {
//                Button("", systemImage: "plus") {
//                    isNewPresented.toggle()
//                }
//            }
            .sheet(isPresented: $isEditPresented) {
                if let book = viewModel.book {
                    BookDetailEditView()
                        .environmentObject(BookDetailViewModel(book: book))
                }
            }
        }
    }
}

#Preview {
    let viewModel = LibraryViewModel()
    viewModel.getCDBooks()
    
    return AllBookListView()
        .environmentObject(viewModel)
}

#Preview("LibraryView") {
    LibraryView()
}

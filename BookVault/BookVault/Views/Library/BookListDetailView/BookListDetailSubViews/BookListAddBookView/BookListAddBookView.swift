//
//  BookListAddBookView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 27.07.24.
//

import SwiftUI

struct BookListAddBookView: View {
    @StateObject var viewModel = BookListAddBookViewModel()
    @State var list: CDList
    @Binding var isNewPresented: Bool

    var body: some View {
        NavigationStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            Form {
                Section("Deine Bücher") {
                    List(viewModel.filteredBooks) { book in
                        HStack {
                            Text(book.title ?? "no title")
                            Spacer()
                            if viewModel.selectedBooks.contains(book) {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            } else {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.ultraThinMaterial)
                            }
                        }
                        .onTapGesture {
                            if viewModel.selectedBooks.contains(book) {
                                viewModel.selectedBooks.remove(book)
                            } else {
                                viewModel.selectedBooks.insert(book)
                            }
                        }
                    }
                }
                Button("Bücher hinzufügen") {
                    viewModel.addSelectedBooksToList(list)
                    isNewPresented.toggle()
                }
            }
            .onAppear {
                viewModel.getCDBooks()
                viewModel.saveBooksFromList(list)
            }
            .navigationTitle("Bücher hinzufügen")
        }
    }
}

#Preview {
    @State var isNewPresented = true
    let viewModel = BookListDetailViewModel()
    viewModel.getCDLists()

    if let list = viewModel.lists.first {
        return BookListAddBookView(list: list, isNewPresented: $isNewPresented)
    }

    return VStack {
            Text("Diesen Text solltest Du eigentlich nicht sehen.")
            Text("Ein Fehler ist aufgetreten.")
        }
}

#Preview("LibraryView") {
    LibraryView()
}

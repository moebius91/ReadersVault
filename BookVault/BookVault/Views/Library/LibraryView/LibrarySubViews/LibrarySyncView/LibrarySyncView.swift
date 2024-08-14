//
//  LibrarySyncView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 14.08.24.
//

import SwiftUI

struct LibrarySyncView: View {
    @EnvironmentObject var viewModel: LibrarySyncViewModel

    var body: some View {
        List(viewModel.filteredBooks) { book in
            Text(book.title)
                .bold()
                .swipeActions {
                    Button("", systemImage: "plus") {
                        viewModel.syncFireBookToCoreData(fireBook: book)
                    }
                }
        }
//        .onAppear {
//            viewModel.fetchBooks()
//        }
        .navigationTitle("Synchronisieren")
    }
}

#Preview {
    @StateObject var viewModel = LibraryViewModel()
    viewModel.getCDBooks()

    return NavigationStack {
        LibrarySyncView()
            .environmentObject(LibrarySyncViewModel(books: viewModel.books))
    }
}

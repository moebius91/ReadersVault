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
        NavigationStack {
            Form {
                if !viewModel.localOnlyBooks.isEmpty {
                    Section("Lokale Bücher") {
                        List(viewModel.localOnlyBooks) { book in
                            Text(book.title ?? "no title")
                                .bold()
                                .swipeActions {
                                    Button(role: .destructive, action: {
                                        viewModel.syncCoreDataToFireBook(book)
                                    }) {
                                        Label("", systemImage: "plus")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                }
                if !viewModel.fireBaseOnlyBooks.isEmpty {
                    Section("Cloud Bücher") {
                        List(viewModel.fireBaseOnlyBooks) { book in
                            Text(book.title)
                                .bold()
                                .swipeActions {
                                    Button(role: .destructive, action: {
                                        viewModel.syncFireBookToCoreData(fireBook: book)
                                    }) {
                                        Label("", systemImage: "plus")
                                    }
                                    .tint(.blue)
                                }
                        }
                        .navigationTitle("Synchronisieren")
                    }
                }
                if !viewModel.syncedBooks.isEmpty {
                    Section("Synchronisierte Bücher") {
                        List(viewModel.syncedBooks) { book in
                            Text(book.title)
                                .bold()
                        }
                    }
                }
            }
            .navigationTitle("Synchronisieren")
            .onAppear {
                viewModel.start()
        }
        }
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

#Preview("Navi") {
    NavigatorView()
}

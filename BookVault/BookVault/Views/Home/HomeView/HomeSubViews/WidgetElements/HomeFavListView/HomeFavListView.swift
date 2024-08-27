//
//  HomeFavListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 26.08.24.
//

import SwiftUI

struct HomeFavListView: View {
    @StateObject private var viewModel = HomeFavListViewModel()

    var body: some View {
        VStack {
            if viewModel.books.isEmpty { Text("Favoritenbücher sind leer!")}
        }
        // Logik welche zwischen einem Buch und mehreren Büchern in den Favs unterscheidet
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer()
                ForEach(viewModel.books) { book in
                    HStack {
                        NavigationLink(destination: {
                            BookDetailView(viewModel: BookDetailViewModel(book: book), syncViewModel: BookDetailSyncViewModel(book: book))
                        }) {
                            HStack {
                                if let imageData = book.coverImage, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        .clipped()
                                }
                                VStack(alignment: .trailing) {
                                    Spacer()
                                    Text("Zum\nBuch")
                                        .padding(.bottom, 4)
                                    Label("", systemImage: "arrow.right")
                                        .padding(.leading, 4)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.getAllFavoriteBooks()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
    }
}

#Preview {
    return NavigationStack {
        HomeFavListView()
    }
}

#Preview("HomeElementView") {
    let homeViewModel = HomeViewModel()

    if let widget = homeViewModel.widgets.last {
        if let element = widget.elements.first {
            return HomeElementView(element: element)
        }
    }

    let viewModel = LibraryViewModel()
    viewModel.getCDBooks()

    if let book = viewModel.books.first {
        if let cover = book.coverImage, let bookId = book.id, let bookTitle = book.title {
            let widgetBook = WidgetBook(cdBookId: bookId, title: bookTitle, cover: cover)
            return HomeElementView(element: WidgetElement(name: "Testelement", type: .book, book: widgetBook))
        }
    }

    return HomeElementView(element: WidgetElement(name: "Testelement", type: .book, book: WidgetBook(cdBookId: UUID(), title: "Buchtitel")))
}

//
//  HomeSingleBookView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeSingleBookView: View {
    @StateObject private var viewModel = HomeBooksViewModel()
    let book: WidgetBook

    var body: some View {
        NavigationLink(destination: {
            if let cdBook = viewModel.getCDBookForWidgetBook(book) {
                BookDetailView(viewModel: BookDetailViewModel(book: cdBook), syncViewModel: BookDetailSyncViewModel(book: cdBook))
            }
        }, label: {
            HStack {
                if let imageData = book.cover, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .clipped()
                }
                Spacer()
                VStack {
                    Text(book.title)
                        .lineLimit(3)
                        .truncationMode(.tail)
                        .padding(.horizontal, 16)
                    HStack {
                        Spacer()
                        Label("", systemImage: "arrow.right")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding()
        })
    }
}

#Preview {
    let viewModel = LibraryViewModel()
    viewModel.getCDBooks()

    return NavigationStack {
        if let book = viewModel.books.first {
            if let cover = book.coverImage, let bookId = book.id, let bookTitle = book.title {
                let widgetBook = WidgetBook(cdBookId: bookId, title: bookTitle, cover: cover)
                HomeSingleBookView(book: widgetBook)
            }
        } else {
            let book = WidgetBook(cdBookId: UUID(), title: "Testbuch")
            HomeSingleBookView(book: book)
        }
    }
}

#Preview("HomeView") {
    HomeView()
}

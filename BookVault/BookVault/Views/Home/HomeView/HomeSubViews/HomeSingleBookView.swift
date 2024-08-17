//
//  HomeSingleBookView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeSingleBookView: View {
    let book: WidgetBook

    var body: some View {
        HStack {
            if let imageData = book.cover, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .clipped()
                    .padding(.leading)
            }
            Text(book.title)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    let viewModel = LibraryViewModel()
    viewModel.getCDBooks()

    if let book = viewModel.books.first {
        if let cover = book.coverImage, let bookId = book.id, let bookTitle = book.title {
            let widgetBook = WidgetBook(cdBookId: bookId, title: bookTitle, cover: cover)
            return HomeSingleBookView(book: widgetBook)
        }
    }
    let book = WidgetBook(cdBookId: UUID(), title: "Testbuch")
    return HomeSingleBookView(book: book)
}

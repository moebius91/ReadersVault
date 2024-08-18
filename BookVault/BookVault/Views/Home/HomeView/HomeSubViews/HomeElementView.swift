//
//  HomeElementView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeElementView: View {
    let element: WidgetElement

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.systemGray5))
                .padding(.horizontal)
            VStack {
                switch element.type {
                case .standard:
                    Text("standard")
                        .padding()
                        .padding(.leading)
                case .book:
                    if let book = element.book {
                        HomeSingleBookView(book: book)
                    }
                case .books:
                    if let books = element.books {
                        HomeBooksView(books: books)
                    }
                case .stats:
                    if let stats = element.stats {
                        HomeStatsView(stats: stats)
                    }
                case .list:
                    if let list = element.list {
                        HomeSingleListView(list: list)
                    }
                case .lists:
                    if let lists = element.lists {
                        HomeListsView(lists: lists)
                    }
                }
            }
        }
        .frame(height: 150)
    }
}

#Preview {
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

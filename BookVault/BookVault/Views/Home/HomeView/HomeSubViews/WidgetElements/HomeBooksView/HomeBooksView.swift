//
//  HomeBooksView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct HomeBooksView: View {
    @StateObject private var viewModel = HomeBooksViewModel()
    let books: [WidgetBook]

    var body: some View {
        HStack {
            Spacer()
            ForEach(Array(books.enumerated()), id: \.element.id) { index, book in
                HStack {
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
                            VStack(alignment: .trailing) {
                                Spacer()
                                Text("Zum\nBuch")
                                    .padding(.bottom, 4)
                                Label("", systemImage: "arrow.right")
                                    .padding(.leading, 4)
                                Spacer()
                            }
                        }
                    })
                }
                if index == 0 {
                    Divider()
                        .background(.primary)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview("HomeElementView") {
    return NavigationStack {
        let homeViewModel = HomeViewModel()

        if let widget = homeViewModel.widgets.last {
            if let element = widget.elements.first {
                HomeElementView(element: element)
            }
        }
        EmptyView()
    }
}

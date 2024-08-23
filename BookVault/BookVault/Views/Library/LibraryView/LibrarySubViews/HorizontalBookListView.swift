//
//  HorizontalBookListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 11.07.24.
//

import SwiftUI
import CoreData

struct HorizontalBookListView: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if !viewModel.books.isEmpty {
            Section {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.books.prefix(5), id: \.self) { book in
                            NavigationLink(destination: {
                                BookDetailView(viewModel: BookDetailViewModel(book: book), syncViewModel: BookDetailSyncViewModel(book: book))
                            }, label: {
                                VStack {
                                    ZStack(alignment: .topLeading) {
                                        HStack {
                                            Spacer()
                                            if let imageData = book.coverImage, let uiImage = UIImage(data: imageData) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 100, height: 150)
                                                    .padding(0)
                                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                    .clipped()
                                            } else {
                                                AsyncImage(
                                                    url: book.coverUrl,
                                                    content: { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                                    },
                                                    placeholder: {
                                                        Image(systemName: "photo.artframe")
                                                    }
                                                )
                                                .frame(width: 100, height: 150)
                                                .padding(0)
                                            }
                                            Spacer()
                                        }
                                        HStack {
                                            Button(action: {
                                                viewModel.updateBookFavorite(book)
                                            }) {
                                                if book.isFavorite {
                                                    Image(systemName: "star.fill")
                                                        .resizable()
                                                        .foregroundStyle(.yellow)
                                                        .frame(width: 24, height: 24)
                                                } else {
                                                    Image(systemName: "star")
                                                        .resizable()
                                                        .foregroundStyle(.yellow)
                                                        .frame(width: 24, height: 24)
                                                }
                                            }
                                        }
                                        .padding(4)
                                        .offset(x: 12, y: 4)
                                    }
                                    HStack {
                                        Text(book.title?.truncate(length: 30) ?? "no title")
                                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                                            .padding(0)
                                    }
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(0)
                                .listRowSeparator(.hidden)
                                .frame(width: 100)
                            })
                        }
                        .padding(4)
                        if viewModel.books.count >= 1 {
                            VStack {
                                NavigationLink(destination: {
                                    AllBookListView()
                                        .environmentObject(AllBookListViewModel(books: viewModel.books))
                                }, label: {
                                    Text("Alle\nBücher")
                                })
                            }
                        }
                    }
                    .padding(0)
                }
                .padding(.top, 16)
            } header: {
                Text("Bücher")
                    .bold()
                    .font(.title2)
            }
        } else {
            Text("Keine Bücher in der Bibliothek vorhanden.")
        }
    }

}

#Preview {
    NavigationStack {
        let viewModel = LibraryViewModel()
        viewModel.getCDBooks()

        return HorizontalBookListView()
            .environmentObject(viewModel)
    }
    .frame(height: 280)
}

#Preview("LibraryView") {
    LibraryView()
}

#Preview("NavigatorView") {
    NavigatorView()
}

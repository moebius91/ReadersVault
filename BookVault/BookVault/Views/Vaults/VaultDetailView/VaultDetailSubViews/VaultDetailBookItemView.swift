//
//  VaultDetailBookItemView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.08.24.
//

import SwiftUI

struct VaultDetailBookItemView: View {
    @Environment(\.colorScheme) var colorScheme
    let book: CDBook

    var body: some View {
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
    }
}

#Preview {
    let viewModel = LibraryViewModel()
    viewModel.getCDBooks()

    if let book = viewModel.books.first {
            return VaultDetailBookItemView(book: book)
    }

    return EmptyView()
}

#Preview("VaultListView") {
    @State var path = NavigationPath()
    return NavigationStack {
        VaultListView(path: $path)
    }
}

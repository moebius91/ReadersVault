//
//  NotesBookSelectionView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import SwiftUI

struct NotesBookSelectionView: View {
    @EnvironmentObject var viewModel: NotesListViewModel
    @Binding var path: NavigationPath
    @State private var book: CDBook?

    var body: some View {
        Text("Buch auswählen:")
            .font(.title3)
            .bold()
        Form {
            List(viewModel.books) { book in
                HStack {
                    if let imageData = book.coverImage, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 120)
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
                                Image("photo.artframe")
                            }
                        )
                        .frame(width: 75, height: 120)
                        .padding(0)
                    }
                    Text(book.title ?? "no title")
                    VStack {
                        if viewModel.book == book {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        } else {
                            Image(systemName: "")
                        }
                    }
                    .frame(width: 20)
                }
                .onTapGesture {
                    if viewModel.book == book {
                        viewModel.book = nil
                    } else {
                        viewModel.book = book
                    }
                }
            }
            Section {
                if viewModel.book != nil {
                    NavigationLink(value: "NotesEditView", label: {
                        HStack {
                            Text("Weiter")
                        }
                    })
//                    NavigationLink(destination: {
//                        NotesEditView(path: $path)
//                            .environmentObject(viewModel)
//                    }) {
//                        HStack {
//                            Text("Weiter")
//                        }
//                    }
                }
            }
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    let viewModel = NotesListViewModel()
    viewModel.getCDBooks()

    return NavigationStack {
        NotesBookSelectionView(path: $path)
            .environmentObject(viewModel)
    }
}

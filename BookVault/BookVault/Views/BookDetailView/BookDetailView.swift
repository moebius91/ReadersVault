//
//  BookDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.07.24.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(viewModel.title)) {
                    HStack {
                        Spacer()
                        if let imageData = viewModel.coverImage, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                .clipped()
                        } else {
                            AsyncImage(
                                url: viewModel.coverUrl,
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
                            .frame(width: 150)
                        }
                        Spacer()
                    }
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(.title2)
                            .bold()
                        HStack {
                            Text("Publisher: ")
                                .bold()
                                .font(.subheadline)
                                .padding(.top, 2)
                            Text(viewModel.publisher)
                                .font(.subheadline)
                                .padding(.top, 2)
                        }
                        Spacer()
                        HStack {
                            Text("ISBN: ")
                                .bold()
                                .font(.subheadline)
                            Text(viewModel.isbn)
                                .font(.subheadline)
                        }
                        HStack {
                            Text("ISBN-10: ")
                                .bold()
                                .font(.subheadline)
                            Text("\(viewModel.isbn10 == "")")
                                .font(.subheadline)
                        }
                        HStack {
                            Text("ISBN-13: ")
                                .bold()
                                .font(.subheadline)
                            Text(viewModel.isbn13)
                                .font(.subheadline)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: viewModel.isFavorite ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(viewModel.isFavorite ? .green : .gray)
                            Text("Favorit")
                        }

                        HStack {
                            Image(systemName: viewModel.isOwned ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(viewModel.isOwned ? .green : .gray)
                            Text("Im Besitz")
                        }

                        HStack {
                            if (!viewModel.isOwned && !viewModel.isLoaned) || (viewModel.isOwned && !viewModel.isLoaned) {

                            } else {
                                Image(systemName: viewModel.isLoaned ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.isLoaned ? .green : .gray)
                                if !viewModel.isOwned && viewModel.isLoaned {
                                    Text("Verliehen")
                                } else if viewModel.isOwned && viewModel.isLoaned {
                                    Text("Geliehen")
                                }
                            }
                        }
                        if !viewModel.shortDescription.isEmpty {
                            Text("Beschreibung")
                                .font(.headline)
                                .padding(.top, 5)

                            Text(viewModel.shortDescription)
                                .font(.body)
                                .padding(.bottom, 5)
                        }

                        if !viewModel.titleLong.isEmpty {
                            Text("Long Title")
                                .font(.headline)

                            Text(viewModel.titleLong)
                                .font(.body)
                        }
                    }
                }
                if !viewModel.lists.isEmpty {
                    Section(header: Text("Listen")) {
                        List(viewModel.lists) { list in
                            NavigationLink(destination: {
                                BookListDetailView()
                                    .environmentObject(BookListDetailViewModel())
                                    .environmentObject(list)
                            }, label: {
                                Text(list.title ?? "no name")
                            })
                        }
                    }
                }
                if !viewModel.notes.isEmpty {
                    Section(header: Text("Notizen")) {
                        List(viewModel.notes) { note in
                            NavigationLink(destination: {
                                NoteDetailView(note: note)
                            }) {
                                Text(note.title ?? "no name")
                            }
                        }
                    }
                }
                if !viewModel.tags.isEmpty {
                    Section(header: Text("Schlagworte")) {
                        List(viewModel.tags) { tag in
                            Text(tag.name ?? "no name")
                        }
                    }
                }
                if !viewModel.categories.isEmpty {
                    Section(header: Text("Kategorien")) {
                        List(viewModel.categories) { category in
                            Text(category.name ?? "no name")
                        }
                    }
                }
            }
            .navigationTitle("Buchdetails")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    viewModel.isSheetShown = true
                }, label: {
                    Label("Bearbeiten", systemImage: "pencil")
                })
            }
            .sheet(isPresented: $viewModel.isSheetShown) {
                BookDetailEditView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()

    let book = libraryViewModel.books.first

    guard book != nil else {
        return TestView()
    }

    let viewModel = BookDetailViewModel(book: book!)

    return BookDetailView(viewModel: viewModel)
}

#Preview("Navi") {
    NavigatorView()
}

//
//  BookDetailEditView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.07.24.
//

import SwiftUI
import PhotosUI

struct BookDetailEditView: View {
    @EnvironmentObject var viewModel: BookDetailViewModel

    var body: some View {
        Form {
            Section(header: Text("Cover")) {
                HStack {
                    Spacer()
                    if let selectedImage = viewModel.selectedImage {
                        VStack {
                            HStack {
                                Spacer()
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                Spacer()
                            }
                        }
                    } else {
                        if let imageData = viewModel.coverImage, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                .clipped()
                        }
                    }
                    Spacer()
                }
                PhotosPicker(selection: $viewModel.photosPickerItem) {
                    Label("Cover auswählen", systemImage: "photo")
                }
                .onChange(of: viewModel.photosPickerItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                            viewModel.selectedImage = image
                        }
                    }
                }
                Button("Cover wiederherstellen", systemImage: "arrow.clockwise") {
                    viewModel.restoreCoverFromApi()
                }
            }
            Section(header: Text("Details")) {
                TextField("Title", text: $viewModel.title)
                TextField("Langer Titel", text: $viewModel.titleLong)
                TextField("Publisher", text: $viewModel.publisher)
                TextField("ISBN", text: $viewModel.isbn)
                TextField("ISBN 10", text: $viewModel.isbn10)
                TextField("ISBN 13", text: $viewModel.isbn13)
            }
            Section(header: Text("Header")) {
                TextField("Kurze Beschreibung", text: $viewModel.shortDescription)
                Toggle("Favorit?", isOn: $viewModel.isFavorite)
                Toggle("Gelesen?", isOn: $viewModel.isRead)
                Toggle("Im Besitz?", isOn: $viewModel.isOwned)
                if viewModel.isOwned {
                    Toggle("Geliehen?", isOn: $viewModel.isLoaned)
                } else {
                    Toggle("Verliehen?", isOn: $viewModel.isLoaned)
                }
            }
            Section {
                Button(action: {
                    viewModel.updateCDBook()
                    viewModel.getBookFromDB()
                    viewModel.isSheetShown = false
                }, label: {
                    HStack {
                        Spacer()
                        Text("Speichern")
                        Spacer()
                    }
                })
//                Button(action: {
//                    viewModel.deleteBook(viewModel.book)
//                    viewModel.isSheetShown = false
//                }, label: {
//                    HStack {
//                        Spacer()
//                        Text("Löschen")
//                            .foregroundStyle(.red)
//                        Spacer()
//                    }
//                })
            }
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()
    let book = libraryViewModel.books.first

    guard book != nil else {
        return VStack {
            Text("Diesen Text solltest Du eigentlich nicht sehen.")
            Text("Ein Fehler ist aufgetreten.")
        }
    }

    let viewModel = BookDetailViewModel(book: book!)

    return NavigationStack {
        BookDetailEditView()
            .environmentObject(viewModel)
    }
}

#Preview("BookDetailView") {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()
    let book = libraryViewModel.books.first

    guard book != nil else {
        return VStack {
            Text("Diesen Text solltest Du eigentlich nicht sehen.")
            Text("Ein Fehler ist aufgetreten.")
        }
    }

    let viewModel = BookDetailViewModel(book: book!)

    return BookDetailView(viewModel: viewModel)
}

#Preview("Navi") {
    NavigatorView()
}

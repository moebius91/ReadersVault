//
//  NewBookEditView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 26.07.24.
//

import SwiftUI
import PhotosUI

struct NewBookEditView: View {
    @EnvironmentObject var viewModel: NewBookEditViewModel
    @Binding var isSheetShown: Bool

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
                Toggle("Favorite", isOn: $viewModel.isFavorite)
                Toggle("Im Besitz?", isOn: $viewModel.isOwned)
                if viewModel.isOwned {
                    Toggle("Geliehen?", isOn: $viewModel.isLoaned)
                } else {
                    Toggle("Verliehen?", isOn: $viewModel.isLoaned)
                }
            }
            Section {
                Button(action: {
                    viewModel.saveBookInCoreData()
                    isSheetShown = false
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
    @State var isSheetShown: Bool = false
    let bookDirect: ApiBook = .init(publisher: "", title: "Testbuch", image: nil, title_long: nil, authors: nil, isbn13: "1234567890123", isbn: "1234567890123", isbn10: nil, synopsis: nil)

    return NewBookEditView(isSheetShown: $isSheetShown)
        .environmentObject(NewBookEditViewModel(book: bookDirect))
}

#Preview("SearchView") {
    SearchView()
}

//
//  AllBookListNewBookView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import SwiftUI
import PhotosUI

struct AllBookListNewBookView: View {
    @EnvironmentObject var viewModel: AllBookListViewModel
    @Binding var isSheetShown: Bool

    var body: some View {
        NavigationStack {
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
                            } else {
                                Image(systemName: "photo.artframe")
                                    .resizable()
                                    .frame(width: 150, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                    .padding(.vertical, 16)
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
                Section(header: Text("Autoren")) {
                    NavigationLink(
                        destination: {
                            AuthorSelectionView(selectedAuthors: $viewModel.selectedAuthors)
                        }) {
                            Text("Autoren auswählen")
                        }
                    if !viewModel.selectedAuthors.isEmpty {
                        List(Array(viewModel.selectedAuthors), id: \.self) { author in
                            Text(author.name ?? "no name")
                                .foregroundStyle(.green)
                        }
                    }
                }
                Section(header: Text("Schlagworte und Kategorien")) {
                    NavigationLink(
                        destination: {
                            TagsSelectionView(selectedTags: $viewModel.selectedTags)
                        }) {
                            Text("Schlagworte auswählen")
                        }
                    if !viewModel.selectedTags.isEmpty {
                        List(Array(viewModel.selectedTags), id: \.self) { tag in
                            Text(tag.name ?? "no name")
                                .foregroundStyle(.green)
                        }
                    }
                    NavigationLink(
                        destination: {
                            CategoriesSelectionView(selectedCategories: $viewModel.selectedCategories)
                        }) {
                            Text("Kategorien auswählen")
                        }
                    if !viewModel.selectedCategories.isEmpty {
                        List(Array(viewModel.selectedCategories), id: \.self) { category in
                            Text(category.name ?? "no name")
                                .foregroundStyle(.green)
                        }
                    }
                }
                Section {
                    Button(action: {
                        viewModel.saveBookInCoreData()
                        viewModel.clear()
                        isSheetShown = false
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Speichern")
                            Spacer()
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    @State var isSheetShown = false

    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()

    let viewModel = AllBookListViewModel(books: libraryViewModel.books)

    return AllBookListNewBookView(isSheetShown: $isSheetShown)
        .environmentObject(viewModel)
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()

    let viewModel = AllBookListViewModel(books: libraryViewModel.books)

    return AllBookListView()
        .environmentObject(viewModel)
}

#Preview("LibraryView") {
    LibraryView()
}

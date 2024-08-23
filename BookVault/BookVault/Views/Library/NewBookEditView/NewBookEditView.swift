//
//  NewBookEditView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 26.07.24.
//

import SwiftUI
import PhotosUI

struct NewBookEditView: View {
    @EnvironmentObject var viewModel: NewBookEditViewModel
    @Binding var isSheetShown: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Cover")) {
                    if viewModel.selectedImage != nil || viewModel.coverImage != nil {
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
                    CustomTextField(title: "Title", text: $viewModel.title)
                    CustomTextField(title: "Langer Titel", text: $viewModel.titleLong)
                    CustomTextField(title: "Publisher", text: $viewModel.publisher)
                        .disabled(true)
                    CustomTextField(title: "ISBN", text: $viewModel.isbn)
                        .disabled(true)
                    CustomTextField(title: "ISBN 10", text: $viewModel.isbn10)
                        .disabled(true)
                    CustomTextField(title: "ISBN 13", text: $viewModel.isbn13)
                        .disabled(true)
                }
                Section("Kurze Beschreibung") {
                    TextField("Kurze Beschreibung", text: $viewModel.shortDescription)
                }
                Section {
                    Toggle("Favorit?", isOn: $viewModel.isFavorite)
                    Toggle("Gelesen?", isOn: $viewModel.isRead)
                    Toggle("Im Besitz?", isOn: $viewModel.isOwned)
                    if viewModel.isOwned {
                        Toggle("Geliehen?", isOn: $viewModel.isLoaned)
                    } else {
                        Toggle("Verliehen?", isOn: $viewModel.isLoaned)
                    }
                }
                Section("Kategorien und Schlagworte") {
                    NavigationLink(
                        destination: {
                            TagsSelectionView(selectedTags: $viewModel.selectedTags)
                        }) {
                            Text("Schlagworte auswählen")
                                .foregroundStyle(.link)
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
                                .foregroundStyle(.link)
                        }
                    if !viewModel.selectedCategories.isEmpty {
                        List(Array(viewModel.selectedCategories), id: \.self) { category in
                            Text(category.name ?? "no name")
                                .foregroundStyle(.green)
                        }
                    }
                }
            }
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
            .buttonStyle(BorderedProminentButtonStyle())
            .padding()
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

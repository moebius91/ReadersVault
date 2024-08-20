//
//  CreateVaultSheetView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import SwiftUI

struct CreateVaultSheetView: View {
    @EnvironmentObject var viewModel: VaultListViewModel

    @State private var newVaultName: String = ""

    @Binding var isPresented: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section("Vaultname") {
                    TextField("Vaultname eingeben", text: $newVaultName)
                }
                Section("Bücher und Notizen") {
                    NavigationLink(
                        destination: {
                            BooksSelectionView(selectedBooks: $viewModel.selectedBooks)
                        }) {
                            Text("Bücher auswählen")
                        }
                    if !viewModel.selectedBooks.isEmpty {
                        List(Array(viewModel.selectedBooks), id: \.self) { book in
                            Text(book.title ?? "no title")
                                .foregroundStyle(.green)
                        }
                    }
                    NavigationLink(
                        destination: {
                            NotesSelectionView(selectedNotes: $viewModel.selectedNotes)
                        }) {
                            Text("Notizen auswählen")
                        }
                    if !viewModel.selectedNotes.isEmpty {
                        List(Array(viewModel.selectedNotes), id: \.self) { note in
                            Text(note.title ?? "no title")
                                .foregroundStyle(.green)
                        }
                    }
                }
                Section("Schlagworte und Kategorien") {
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
                        if !newVaultName.isEmpty {
                            viewModel.createVault(name: newVaultName)
                            isPresented.toggle()
                            viewModel.getCDVaults()
                        }
                        //                else {
                        //                    alertIsPresented = true
                        //                }
                    }, label: {
                        Text("Speichern")
                    })
                }
            }
        }
    }
}

#Preview {
    @State var isPresented: Bool = true
    return NavigationStack {
        CreateVaultSheetView(isPresented: $isPresented)
            .environmentObject(VaultListViewModel())
    }
}

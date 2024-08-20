//
//  BookNewNoteView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 20.08.24.
//

import SwiftUI

struct BookNewNoteView: View {
    @EnvironmentObject var viewModel: BookDetailViewModel
    @State private var newNoteTitle: String = ""
    @State private var newNoteContent: String = ""

    @State private var alertIsPresented: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Für das Buch:")
                    .bold()
                    .padding(.horizontal)
                    .padding(.bottom, 0)
                Text(viewModel.book.title ?? "no title")
                    .padding(.top, 0)
                    .padding()
                Form {
                    Section(content: {
                        TextField("Titel eingeben", text: $newNoteTitle)
                        TextField("Notiz eingeben", text: $newNoteContent)
                    }, header: {
                        Text("Notizinhalt")
                    })
                    Section(content: {
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
                    }, header: {
                        Text("Schlagworte und Kategorien")
                    })
                    Section(content: {
                        Button(action: {
                            if !newNoteTitle.isEmpty && !newNoteContent.isEmpty {
                                viewModel.createNote(title: newNoteTitle, content: newNoteContent)
                                viewModel.isNoteSheetShown = false
                            } else {
                                alertIsPresented = true
                            }
                        }, label: {
                            Text("Speichern")
                        })
                    }, header: {
                        //
                    })
                }
                .navigationTitle("Notiz erstellen")
                .alert("Notiz nicht erstellt!\nTitel und Inhalt dürfen nicht leer sein.", isPresented: $alertIsPresented) {
                    Button("OK", role: .cancel) {
                        alertIsPresented = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    BookNewNoteView()
//        .environmentObject(BookDetailViewModel())
//}

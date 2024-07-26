//
//  NotesEditView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import SwiftUI

struct NotesEditView: View {
    @EnvironmentObject var viewModel: NotesListViewModel
    @State private var newNoteTitle: String = ""
    @State private var newNoteContent: String = ""

    @State private var alertIsPresented: Bool = false

    @Binding var path: NavigationPath

    var body: some View {
        VStack(alignment: .leading) {
            Text("Für das Buch:")
                .bold()
                .padding(.horizontal)
                .padding(.bottom, 0)
            Text(viewModel.book?.title ?? "no title")
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
                            TagSelectionView()
                                .environmentObject(viewModel)
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
                            CategorySelectionView()
                                .environmentObject(viewModel)
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
                            path.removeLast(path.count)
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

#Preview {
    @State var path = NavigationPath()

    let viewModel = NotesListViewModel()
    viewModel.getCDBooks()
    viewModel.book = viewModel.books.first!

    return NavigationStack {
        NotesEditView(path: $path)
            .environmentObject(viewModel)
    }
}

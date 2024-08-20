//
//  NotesListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 02.07.24.
//

import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesListViewModel()
    @State var path = NavigationPath()

    @State var isPresented = false
    @State var searchText = ""

    var body: some View {
        NavigationStack(path: $path) {
            if !viewModel.books.isEmpty {
                if viewModel.notes.isEmpty {
                    Text("Du hast keine Notizen.")
                }
                List(viewModel.notes) { note in
                    NavigationLink(destination: {
                        NoteDetailView()
                            .environmentObject(NoteDetailViewModel(note: note))
                    }, label: {
                        Text(note.title ?? "no title")
                    })
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            viewModel.editTitle = note.title ?? ""
                            viewModel.editContent = note.content ?? ""
                            viewModel.note = note
                            isPresented = true
                        }) {
                            Label("Löschen", systemImage: "pencil")
                                .tint(.blue)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive, action: {
                            viewModel.deleteCDNotes(note)
                        }) {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }
                .navigationTitle("Notizen")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        NavigationLink(value: "VaultListView", label: {
                            Text("Vaults")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink(value: "NotesBookSelectionView", label: {
                            Label("", systemImage: "plus")
                        })
                    }
                }
                .navigationDestination(for: String.self) { textValue in
                    switch textValue {
                    case "NotesBookSelectionView":
                        NotesBookSelectionView(path: $path)
                            .environmentObject(viewModel)
                    case "NotesEditView":
                        NotesEditView(path: $path)
                            .environmentObject(viewModel)
                    case "VaultListView":
                        VaultListView(path: $path)
                    case "BookDetailView":
                        NotesBookSelectionView(path: $path)
                            .environmentObject(viewModel)
                    default:
                        EmptyView()
                    }
                }
            } else {
                Text("Füge erst Bücher hinzu.")
            }
        }
        .onAppear {
            viewModel.getCDNotes()
            viewModel.getCDBooks()
        }
        .sheet(isPresented: $isPresented, onDismiss: {
            viewModel.getCDNotes()
            viewModel.getCDBooks()
        }) {
            // NotizbearbeitenView hinzufügen
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Label("", systemImage: "xmark")
                    })
                }
                Text("Notiz bearbeiten:")
                    .bold()
                Form {
                    Section {
                        TextField("Titel", text: $viewModel.editTitle)
                        TextField("Inhalt", text: $viewModel.editContent)
                    }
                    Section {
                        Button(action: {
                            viewModel.updateNote()
                            isPresented = false
                        }, label: {
                            Text("Speichern")
                        })
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        NotesListView()
    }
}

#Preview("Navi") {
    NavigatorView()
}

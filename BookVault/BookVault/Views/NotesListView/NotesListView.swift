//
//  NotesListView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 02.07.24.
//

import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesListViewModel()
    @State var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            if !viewModel.books.isEmpty {
                List(viewModel.notes) { note in
                    NavigationLink(destination: {
                        NoteDetailView(note: note)
                    }, label: {
                        Text(note.title ?? "no title")
                    })
                    .swipeActions {
                        Button(role: .destructive, action: {
                            viewModel.deleteCDNotes(note)
                        }) {
                            Label("Löschen", systemImage: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
                .navigationTitle("Notizen")
                .toolbar {
                    NavigationLink(value: "NotesBookSelectionView", label: {
                        Label("", systemImage: "plus")
                    })
                    .navigationDestination(for: String.self) { textValue in
                        if textValue == "NotesBookSelectionView" {
                            NotesBookSelectionView(path: $path)
                                .environmentObject(viewModel)
                        } else if textValue == "NotesEditView" {
                            NotesEditView(path: $path)
                                .environmentObject(viewModel)
                        }
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

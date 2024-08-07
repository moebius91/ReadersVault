//
//  NoteDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 24.07.24.
//

import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var viewModel: NoteDetailViewModel

    @State private var isSheetShown = false

    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.note.content ?? "")
                    Spacer()
                }
                Spacer()
            }
            .toolbar {
                Button(action: {
                    viewModel.editTitle = viewModel.note.title ?? ""
                    viewModel.editContent = viewModel.note.content ?? ""
                    isSheetShown = true
                }, label: {
                    Label("Bearbeiten", systemImage: "pencil")
                })
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $isSheetShown) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isSheetShown = false
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
                            isSheetShown = false
                        }, label: {
                            Text("Speichern")
                        })
                    }
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Notiz: \(viewModel.note.title ?? "no title")")
    }
}

#Preview {
    NavigationStack {
        NotesListView()
    }
}

//
//  NotesSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import SwiftUI

struct NotesSelectionView: View {
    @StateObject var viewModel = NotesSelectionViewModel()
    @Binding var selectedNotes: Set<CDNote>

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredNotes, id: \.self) { note in
                HStack {
                    Text(note.title ?? "no title")
                    Spacer()
                    if selectedNotes.contains(note) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedNotes.contains(note) {
                        selectedNotes.remove(note)
                    } else {
                        selectedNotes.insert(note)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Wähle Notizen")
        .onAppear {
            viewModel.getCDNotes()
        }
    }
}

#Preview {
    @State var selectedNotes: Set<CDNote> = []
    return NotesSelectionView(selectedNotes: $selectedNotes)
}

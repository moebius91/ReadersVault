//
//  TagSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import SwiftUI

struct TagSelectionView: View {
    @EnvironmentObject var viewModel: NotesListViewModel

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredTags, id: \.self) { tag in
                HStack {
                    Text(tag.name ?? "no name")
                    Spacer()
                    if viewModel.selectedTags.contains(tag) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if viewModel.selectedTags.contains(tag) {
                        viewModel.selectedTags.remove(tag)
                    } else {
                        viewModel.selectedTags.insert(tag)
                    }
                }
            }
            .listStyle(.plain)

            Button(action: {
                viewModel.isPresented = true
            }, label: {
                Text("Neues Schlagwort hinzufügen")
            })
            Spacer()
        }
        .navigationTitle("Select Tags")
        .onAppear {
            viewModel.getCDTags()
        }
        .sheet(isPresented: $viewModel.isPresented) {
            CreateTagView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    let viewModel = NotesListViewModel()
    viewModel.getCDTags()

    return TagSelectionView()
        .environmentObject(viewModel)
}

#Preview("NotesListView") {
    return NavigationStack {
        NotesListView()
    }
}

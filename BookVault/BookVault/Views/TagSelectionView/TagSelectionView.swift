//
//  TagSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import SwiftUI

struct TagSelectionView: View {
    @StateObject var viewModel = TagSelectionViewModel()
    @Binding var selectedTags: Set<CDTag>

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredTags, id: \.self) { tag in
                HStack {
                    Text(tag.name ?? "no name")
                    Spacer()
                    if selectedTags.contains(tag) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedTags.contains(tag) {
                        selectedTags.remove(tag)
                    } else {
                        selectedTags.insert(tag)
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
        .navigationTitle("Wähle Schlagworte")
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
    @State var selectedTags: Set<CDTag> = []

    return TagSelectionView(selectedTags: $selectedTags)
}

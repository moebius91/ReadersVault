//
//  AuthorSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import SwiftUI

struct AuthorSelectionView: View {
    @StateObject var viewModel = AuthorSelectionViewModel()
    @Binding var selectedAuthors: Set<CDAuthor>

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredAuthors, id: \.self) { author in
                HStack {
                    Text(author.name ?? "no name")
                    Spacer()
                    if selectedAuthors.contains(author) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedAuthors.contains(author) {
                        selectedAuthors.remove(author)
                    } else {
                        selectedAuthors.insert(author)
                    }
                }
            }
            .listStyle(.plain)

            Button(action: {
                viewModel.isPresented = true
            }, label: {
                Text("Neue Autoren hinzufügen")
            })
            Spacer()
        }
        .navigationTitle("Wähle Autoren")
        .onAppear {
            viewModel.getCDAuthors()
        }
        .sheet(isPresented: $viewModel.isPresented) {
            CreateAuthorView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    @State var selectedAuthors: Set<CDAuthor> = []

    return AuthorSelectionView(selectedAuthors: $selectedAuthors)
}

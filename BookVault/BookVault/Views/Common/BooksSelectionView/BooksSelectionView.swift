//
//  BooksSelectionView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import SwiftUI

struct BooksSelectionView: View {
    @StateObject var viewModel = BooksSelecitonViewModel()
    @Binding var selectedBooks: Set<CDBook>

    var body: some View {
        VStack {
            CustomSearchBar(text: $viewModel.searchText)
                .padding(.horizontal)
            List(viewModel.filteredBooks, id: \.self) { book in
                HStack {
                    Text(book.title ?? "no title")
                    Spacer()
                    if selectedBooks.contains(book) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedBooks.contains(book) {
                        selectedBooks.remove(book)
                    } else {
                        selectedBooks.insert(book)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Wähle Bücher")
        .onAppear {
            viewModel.getCDBooks()
        }
    }
}

#Preview {
    @State var selectedBooks: Set<CDBook> = []
    return BooksSelectionView(selectedBooks: $selectedBooks)
}

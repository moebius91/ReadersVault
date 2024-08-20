//
//  BookToListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 20.08.24.
//

import SwiftUI

struct BookToListView: View {
    @EnvironmentObject var viewModel: BookDetailViewModel
    @State var selectedLists: Set<CDList> = []

    var body: some View {
        VStack {
            if viewModel.filteredLists.isEmpty {
                Text("Das Buch ist in allen vorhandenen Listen enthalten.")
                    .padding()
            }
            List(viewModel.filteredLists) { list in
                HStack {
                    Text(list.title ?? "no title")
                    Spacer()
                    if selectedLists.contains(list) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .onTapGesture {
                    if selectedLists.contains(list) {
                        selectedLists.remove(list)
                    } else {
                        selectedLists.insert(list)
                    }
                }
            }
            Button(action: {
                selectedLists.forEach { list in
                    viewModel.addBookToList(list)
                }
                viewModel.isListSheetShown = false
            }, label: {
                Text("Speichern")
            })
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .onAppear {
            viewModel.getAllLists()
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()
    
    if let book = libraryViewModel.books.first {
        return NavigationStack { BookToListView()
                .environmentObject(BookDetailViewModel(book: book))
        }
    }
    
    return EmptyView()
}

#Preview("Navi") {
    NavigatorView()
}

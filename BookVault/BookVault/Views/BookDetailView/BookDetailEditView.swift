//
//  BookDetailEditView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 19.07.24.
//

import SwiftUI

struct BookDetailEditView: View {
    @EnvironmentObject var viewModel: BookDetailViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Title", text: $viewModel.title)
                TextField("Langer Titel", text: $viewModel.titleLong)
                TextField("Publisher", text: $viewModel.publisher)
                TextField("ISBN", text: $viewModel.isbn)
                TextField("ISBN 10", text: $viewModel.isbn10)
                TextField("ISBN 13", text: $viewModel.isbn13)
            }
            Section(header: Text("Header")) {
                TextField("Kurze Beschreibung", text: $viewModel.shortDescription)
                Toggle("Im Besitz?", isOn: $viewModel.isOwned)
                if viewModel.isOwned {
                    Toggle("Geliehen?", isOn: $viewModel.isLoaned)
                } else {
                    Toggle("Verliehen?", isOn: $viewModel.isLoaned)
                }
                Toggle("Favorite", isOn: $viewModel.isFavorite)
            }
            Section {
                Button(action: {
                    viewModel.updateCDBook()
                    viewModel.isSheetShown = false
                }, label: {
                    Text("Speichern")
                })
            }
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()
    let book = libraryViewModel.books.first
    
    guard book != nil else {
        return TestView()
    }
    
    let viewModel = BookDetailViewModel(book: book!)
    
    return NavigationStack {
        BookDetailEditView()
            .environmentObject(viewModel)
    }
}

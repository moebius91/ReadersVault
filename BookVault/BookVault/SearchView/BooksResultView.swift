//
//  BooksResultView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 09.07.24.
//

import SwiftUI

struct BooksResultView: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    
    var body: some View {
        List(viewModel.books, id: \.self) { book in
            Text(book.title)
        }
        .listStyle(.plain)
    }
}

#Preview {
    var viewModel = SearchViewModel()
    viewModel.getBooksByTitle("Tim Burton")
    
    return BooksResultView()
        .environmentObject(viewModel)
}

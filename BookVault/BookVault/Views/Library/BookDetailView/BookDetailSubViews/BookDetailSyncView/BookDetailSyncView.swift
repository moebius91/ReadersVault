//
//  BookDetailSyncView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 13.08.24.
//

import SwiftUI

struct BookDetailSyncView: View {
    @EnvironmentObject var viewModel: BookDetailSyncViewModel
    @Binding var isSyncSheetShown: Bool

    var body: some View {
        if viewModel.isBookSynced {
            Text("Buch ist online")
        } else {
            Text("Buch ist nicht online")
            Button("Buch pushen") {
                viewModel.createBook()
                isSyncSheetShown = false
            }
            .padding()
        }
        Text("Hello, Sync")
    }
}

#Preview {
    @State var isSyncSheetShown = true
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()

    return BookDetailSyncView(isSyncSheetShown: $isSyncSheetShown)
        .environmentObject(BookDetailSyncViewModel(book: libraryViewModel.books.first!))
}

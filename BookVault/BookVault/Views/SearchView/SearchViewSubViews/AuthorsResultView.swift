//
//  AuthorsResultView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 09.07.24.
//

import SwiftUI

struct AuthorsResultView: View {
    @EnvironmentObject private var viewModel: SearchViewModel
    @Binding var isSheetShown: Bool

    var body: some View {
        List(viewModel.authors, id: \.self) { author in

            NavigationLink(destination: {
                BooksResultView(isSheetShown: $isSheetShown)
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.getBooksByAuthor(author)
                    }
            }, label: {
                Text(author)
            })
        }
        .listStyle(.plain)
    }
}

#Preview {
    @State var isSheetShown: Bool = false
    let viewModel = SearchViewModel()
    viewModel.getAuthors("Tim Burton")

    return NavigationStack {
        AuthorsResultView(isSheetShown: $isSheetShown)
            .environmentObject(viewModel)
    }
}

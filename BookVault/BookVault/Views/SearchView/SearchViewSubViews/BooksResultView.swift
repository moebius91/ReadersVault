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
            NavigationLink(destination: {
                SingleBookResultView()
                    .environmentObject(viewModel)
                    .onAppear {
                        viewModel.saveBook(book)
                    }
            }, label: {
                HStack {
                    AsyncImage(
                        url: book.image,
                        content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        },
                        placeholder: {
                            Image("photo.artframe")
                                .foregroundColor(.black)
                        })
                    .frame(width: 75, height: 150)
                    Text(book.title)
                }
                .padding(0)
            })
        }
        .padding(0)
        .listStyle(.plain)
    }
}

#Preview {
    var viewModel = SearchViewModel()
    viewModel.getBooksByTitle("Tim Burton")
    
    return BooksResultView()
        .environmentObject(viewModel)
}

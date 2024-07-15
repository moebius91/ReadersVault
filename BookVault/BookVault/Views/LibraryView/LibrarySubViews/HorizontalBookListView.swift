//
//  HorizontalBookListView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 11.07.24.
//

import SwiftUI

struct HorizontalBookListView: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.books, id:\.self) { book in
                        VStack {
                            ZStack(alignment: .topLeading) {
                                AsyncImage(
                                    url: book.image,
                                    content: { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        
                                    }, placeholder: {
                                        Image("photo.artframe")
                                    }
                                )
                                .frame(width: 75, height: 120)
                                .padding(0)
                                
                                Button(action: {
                                    viewModel.updateBookFavorite(book)
                                }) {
                                    if book.isFavorite {
                                        Image(systemName: "star.fill")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding(4)
                                            .foregroundStyle(.yellow)
                                            .offset(x: 0, y: 4)
                                    } else {
                                        Image(systemName: "star")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .padding(4)
                                            .foregroundStyle(.yellow)
                                            .offset(x: 0, y: 4)
                                    }
                                }
                            }
                            Text(book.title?.truncate(length: 30) ?? "no title")
                                .padding(4)
                            Spacer()
                            // Logik zum testen
                            Button("löschen", action: {
                                viewModel.deleteBook(book)
                            })
                            Spacer()
                        }
                        .padding(0)
                        .listRowSeparator(.hidden)
                        .frame(width: 100)
                    }
                    .padding(0)
                    if viewModel.books.count >= 1 {
                        VStack {
                            NavigationLink(destination: {
                                BookListDetailView()
                                    .environmentObject(viewModel)
                                    .onAppear {
                                        let list = CDList(context: PersistentStore.shared.context)
                                        list.title = "Deine Bücher"
                                        viewModel.saveList(list)
                                        viewModel.getCDBooks()
                                    }
                            }, label: {
                                Text("Alle\nBücher")
                            })
                        }
                    }
                }
                .padding(0)
            }
            .listStyle(.plain)
        } header: {
            Text("Deine Bücher")
                .bold()
                .font(.title2)
        }
    }
    
}


#Preview {
    NavigationStack {
        let viewModel = LibraryViewModel()
        viewModel.getCDBooks()
        
        return HorizontalBookListView()
            .environmentObject(viewModel)
    }
}

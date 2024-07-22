//
//  HorizontalBookListView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 11.07.24.
//

import SwiftUI
import CoreData

struct HorizontalBookListView: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    
    var body: some View {
        if !viewModel.books.isEmpty {
            Section {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.books, id:\.self) { book in
                            NavigationLink(destination: {
                                BookDetailView(viewModel: BookDetailViewModel(book: book))
                            }, label: {
                                VStack {
                                    ZStack(alignment: .topLeading) {
                                        AsyncImage(
                                            url: book.coverUrl,
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
                                        .foregroundStyle(.black)
                                        .padding(4)
                                    Spacer()
                                    Button(action: {
                                        viewModel.deleteBook(book)
                                    }, label: {
                                        Text("Löschen")
                                    })
                                }
                                .padding(0)
                                .listRowSeparator(.hidden)
                                .frame(width: 100)
                            })
                        }
                        .padding(0)
                        if viewModel.books.count >= 1 {
                            VStack {
                                NavigationLink(destination: {
                                    // Eigene View für die Vorgegebenen Liste erstellen
                                    BookListDetailView()
                                        .environmentObject(viewModel)
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
                Text("Bücher")
                    .bold()
                    .font(.title2)
            }
        } else {
            Text("Keine Bücher in der Bibliothek vorhanden.")
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
    .frame(height: 280)
}

#Preview("LibraryView") {
    LibraryView()
}

#Preview("NavigatorView") {
    NavigatorView()
}

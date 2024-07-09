//
//  SearchView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 02.07.24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    @State private var searchString: String = ""
    @State private var selectedIndex = 0
    
    let searchOptions = ["ISBN", "Titel", "Autor"]
    
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Search by", selection: $selectedIndex) {
                    ForEach(0..<searchOptions.count, id: \.self) { index in
                        Text(searchOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
            Spacer()
            VStack {
                if !searchString.isEmpty {
                    if selectedIndex == 0 {
                        HStack {
                            Text("Suchergebnis:")
                                .font(.title2)
                                .bold()
                                .padding(.top,4)
                                .padding(.leading)
                            Spacer()
                        }
                        SingleBookResultView()
                            .environmentObject(viewModel)
                        Spacer()
                    } else if selectedIndex == 1 {
                        VStack {
                            HStack {
                                Text("Suchergebnisse:")
                                    .font(.title2)
                                    .bold()
                                    .padding(.top,4)
                                    .padding(.leading)
                                Spacer()
                            }
                            BooksResultView()
                                .environmentObject(viewModel)
                        }
                    } else if selectedIndex == 2 {
                        HStack {
                            Text("Suchergebnisse:")
                                .font(.title2)
                                .bold()
                                .padding(.top,4)
                                .padding(.leading)
                            Spacer()
                        }
                        AuthorsResultView()
                            .environmentObject(viewModel)
                    }
                }
            }
            .navigationTitle("Suche")
            .searchable(text: $searchString, prompt: "Suche nach \(searchOptions[selectedIndex])")
            .onSubmit(of: .search) {
                if selectedIndex == 0 {
                    if searchString.count == 13 {
                        viewModel.getBookByIsbn(searchString)
                    }
                } else if selectedIndex == 1 {
                    viewModel.getBooksByTitle(searchString)
                }  else if selectedIndex == 2 {
                    viewModel.getAuthors(searchString)
                }
            }
            .onChange(of: selectedIndex) {
                if !searchString.isEmpty {
                    switch selectedIndex {
                    case 0:
                        viewModel.getBookByIsbn(searchString)
                    case 1:
                        viewModel.getBooksByTitle(searchString)
                    case 2:
                        viewModel.getAuthors(searchString)
                    default:
                        fatalError()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}

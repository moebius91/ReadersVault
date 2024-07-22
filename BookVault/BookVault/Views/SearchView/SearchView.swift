//
//  SearchView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 02.07.24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var scannerViewModel = ScannerViewModel()
    
    @State private var searchString: String = ""
    @State private var selectedIndex = 0
    
    let searchOptions = ["ISBN", "Titel", "Autor"]
    
    // 9783424200447
    
    
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
                    switch selectedIndex {
                    case 0:
                        if viewModel.book != nil && searchString.isNumeric {
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
                        }
                    case 1:
                        if !viewModel.books.isEmpty {
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
                        }
                    case 2:
                        if !viewModel.authors.isEmpty {
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
                    default:
                        fatalError()
                    }
                }
            }
            .navigationTitle("Suche")
            .searchable(text: $searchString, prompt: "Suche nach \(searchOptions[selectedIndex])")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        scannerViewModel.isScanning = true
                    }) {
                        Image(systemName: "barcode.viewfinder")
                    }
                }
            }
            .onSubmit(of: .search) {
                switch selectedIndex {
                case 0:
                    searchString.count == 13 ? viewModel.getBookByIsbn(searchString) : nil
                case 1:
                    viewModel.getBooksByTitle(searchString)
                case 2:
                    viewModel.getAuthors(searchString)
                default:
                    fatalError()
                }
            }
            .onChange(of: selectedIndex) {
                if !searchString.isEmpty {
                    switch selectedIndex {
                    case 0:
                        searchString = ""
                        viewModel.book = nil
                        viewModel.getBookByIsbn(searchString)
                    case 1:
                        searchString = ""
                        viewModel.getBooksByTitle(searchString)
                    case 2:
                        searchString = ""
                        viewModel.getAuthors(searchString)
                    default:
                        fatalError()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showSafari) {
                if let url = viewModel.book?.buyURL {
                    SafariView(url: url)
                }
            }
            .sheet(isPresented: $scannerViewModel.isScanning) {
                Text("Klicke auf das entsprechende Kästchen:")
                    .padding()
                    .bold()
                DocumentScannerView(viewModel: scannerViewModel, searchString: $searchString)
                    .onAppear {
                        switch selectedIndex {
                        case 0:
                            scannerViewModel.startBarcodeScanner()
                        case 1, 2:
                            scannerViewModel.startTextScanner()
                        default:
                            break
                        }
                    }
                    .onDisappear {
                        scannerViewModel.scannedText = searchString
                        scannerViewModel.stopScanning()
                    }
            }
        }
    }
}

#Preview {
    SearchView()
}


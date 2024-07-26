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
    @State private var isEditing: Bool = false

    @FocusState private var isTextFieldFocused: Bool

    let searchOptions = ["ISBN", "Titel", "Autor"]

    // 9783424200447

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !isEditing {
                    Text("Suche")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                        .padding(.top, 42)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: isEditing)
                }

                HStack {
                    ScannerSearchBar( text: $searchString, isEditing: $isEditing) {
                        scannerViewModel.isScanning = true
                        isEditing = true
                        isTextFieldFocused = true
                    }
                    .transition(.move(edge: .bottom))
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        isEditing = true
                        performSearch()
                    }
                    if isEditing {
                        Button("Cancel") {
                            withAnimation {
                                isEditing = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                        .padding(.trailing, 10)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .move(edge: .bottom)).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .move(edge: .trailing)).combined(with: .opacity)
                        ))
                    }
                }
                .padding(.horizontal)
                .padding(.top, isEditing ? 0 : 8)
                .animation(.easeInOut(duration: 0.3), value: isEditing)

                if isEditing {
                    VStack(spacing: 0) {
                        Picker("Search by", selection: $selectedIndex) {
                            ForEach(0..<searchOptions.count, id: \.self) { index in
                                Text(searchOptions[index])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: isEditing)
                    }
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
                                        .padding(.top, 4)
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
                                            .padding(.top, 4)
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
                                        .padding(.top, 4)
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
    //            .navigationTitle(isEditing ? "" : "Suche")
    //            .searchable(text: $searchString, prompt: "Suche nach \(searchOptions[selectedIndex])")
    //            .toolbar {
    //                ToolbarItemGroup(placement: .navigationBarTrailing) {
    //                    Button(action: {
    //                        scannerViewModel.isScanning = true
    //                    }) {
    //                        Image(systemName: "barcode.viewfinder")
    //                    }
    //                }
    //            }
//                .onSubmit(of: .search) {
//                    switch selectedIndex {
//                    case 0:
//                        searchString.count == 13 ? viewModel.getBookByIsbn(searchString) : nil
//                    case 1:
//                        viewModel.getBooksByTitle(searchString)
//                    case 2:
//                        viewModel.getAuthors(searchString)
//                    default:
//                        fatalError()
//                    }
//                }
//                .onChange(of: selectedIndex) {
//                    if !searchString.isEmpty {
//                        performSearch()
//                    }
//                }
                .onChange(of: selectedIndex) {
                    if !searchString.isEmpty {
                        switch selectedIndex {
                        case 0:
                            viewModel.book = nil
                            viewModel.authors = []
                            viewModel.books = []
                            viewModel.getBookByIsbn(searchString)
                        case 1:
                            viewModel.authors = []
                            viewModel.books = []
                            viewModel.getBooksByTitle(searchString)
                        case 2:
                            viewModel.authors = []
                            viewModel.books = []
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

    private func performSearch() {
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
}

#Preview {
    SearchView()
}

#Preview("NavigatorView") {
    NavigatorView()
}

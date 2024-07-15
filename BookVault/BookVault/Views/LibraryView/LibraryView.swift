//
//  LibraryView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 12.07.24.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                HorizontalBookListView()
                    .environmentObject(viewModel)
                VerticalBookListsView()
                    .environmentObject(viewModel)
            }
            .toolbar {
                Button("Hinzufügen", systemImage: "plus") {
                    isPresented.toggle()
                }
            }
            .sheet(isPresented: $isPresented) {
                Form {
                    SearchView()
                }
            }
            .navigationTitle("Bibliothek")
            .listStyle(.grouped)
            .onAppear {
                viewModel.getCDBooks()
                viewModel.getCDLists()
            }
        }
    }
}

#Preview {
    LibraryView()
}

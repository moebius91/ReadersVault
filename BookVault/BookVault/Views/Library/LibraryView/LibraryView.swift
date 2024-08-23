//
//  LibraryView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 12.07.24.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @StateObject private var loginViewModel = LoginViewModel.shared

    @State var path = NavigationPath()
    @State private var isPresented: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            List {
                HorizontalBookListView()
                    .environmentObject(viewModel)
                VerticalBookListsView()
                    .environmentObject(viewModel)
            }
            .toolbar {
                if loginViewModel.isLoggedIn() {
                    Button("Hinzufügen", systemImage: "arrow.triangle.2.circlepath") {
                        isPresented.toggle()
                    }
                }
                Button("Hinzufügen", systemImage: "plus") {
                    // Button
                }
            }
            .sheet(isPresented: $isPresented) {
                LibrarySyncView()
                    .environmentObject(LibrarySyncViewModel(books: viewModel.books))
            }
            .sheet(isPresented: $viewModel.showNewListSheet) {
                NewListEditView(showNewListSheet: $viewModel.showNewListSheet, showingAlert: $viewModel.showingAlert)
                    .onDisappear {
                        viewModel.getCDLists()
                    }
            }
            .alert("Liste nicht erstellt!\nTitel darf nicht leer sein.", isPresented: $viewModel.showingAlert) {
                Button("OK", role: .cancel) {
                    viewModel.showingAlert = false
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

#Preview("Navigator") {
    NavigatorView()
}

//
//  LibraryView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 12.07.24.
//

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    
    @State private var newListTitle: String = ""
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
            .sheet(isPresented: $viewModel.presentNewListSheet) {
                Form {
                    TextField("Titel der neuen Liste", text: $newListTitle)
                        .padding(8)
                    Button(action: {
                        if !newListTitle.isEmpty {
                            viewModel.createList(newListTitle)
                            newListTitle = ""
                            viewModel.presentNewListSheet = false
                        } else {
                            viewModel.showingAlert = true
                        }
                    }, label: {
                        Text("Liste hinzufügen")
                    })
                    //                Spacer()
                }
                .padding()
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

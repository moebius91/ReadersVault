//
//  VerticalBookListsView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 11.07.24.
//

import SwiftUI

struct VerticalBookListsView: View {
    @EnvironmentObject var viewModel: LibraryViewModel
    
    @State private var isPresented: Bool = false
    @State private var showingAlert: Bool = false
    
    @State private var newListTitle: String = ""
    
    var body: some View {
        Section {
            Button(action: {
                isPresented = true
            }, label: {
                Text("Neue Liste")
            })
            .buttonStyle(BorderlessButtonStyle())
            ForEach(viewModel.lists) { list in
                HStack {
                    NavigationLink(
                        destination: {
                            BookListDetailView()
                                .environmentObject(viewModel)
                                .onAppear {
                                    viewModel.saveList(list)
                                    viewModel.getBooksByList(list)
                                }
                        }
                    ) {
                        Text(list.title ?? "no title")
                    }
                }
                .swipeActions {
                    Button(role: .destructive, action: {
                        viewModel.deleteList(list)
                    }) {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                    }
                }
                .padding(4)
            }
            .frame(maxWidth: .infinity)
        } header: {
            Text("Deine Listen")
                .bold()
                .font(.title2)
        }
        .padding(0)
        .sheet(isPresented: $isPresented) {
            Form {
                TextField("Titel der neuen Liste", text: $newListTitle)
                    .padding(8)
                Button(action: {
                    if !newListTitle.isEmpty {
                        viewModel.createList(newListTitle)
                        newListTitle = ""
                        isPresented.toggle()
                    } else {
                        showingAlert.toggle()
                    }
                }, label: {
                    Text("Liste hinzufügen")
                })
                //                Spacer()
            }
            .padding()
        }
        .alert("Liste nicht erstellt!\nTitel darf nicht leer sein.", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {
                showingAlert.toggle()
            }
        }
    }
}


#Preview {
    NavigationStack {
        let viewModel = LibraryViewModel()
        viewModel.getCDBooks()
        viewModel.getCDLists()
        
        return VerticalBookListsView()
            .environmentObject(viewModel)
    }
}

//
//  VaultListView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 18.08.24.
//

import SwiftUI

struct VaultListView: View {
    @StateObject private var viewModel = VaultListViewModel()

    @Binding var path: NavigationPath

    var body: some View {
        if viewModel.vaults.isEmpty {
            Text("Keine Vaults angelegt.")
        }
        List(viewModel.vaults) { vault in
            VStack {
                NavigationLink(destination: {
                    VaultDetailView()
                        .environmentObject(VaultDetailViewModel(vault: vault))
                }) {
                    Text(vault.name ?? "")
                }
            }
            .swipeActions(edge: .leading) {
                Button(action: {
                    print("Tu was richtiges!")
                }) {
                    Label("", systemImage: "pencil")
                        .tint(.blue)
                }
            }
            .swipeActions {
                Button(role: .destructive, action: {
                    viewModel.deleteVault(vault)
                }) {
                    Label("", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Vaults")
        .toolbar {
            Button(action: {
                viewModel.isPresented.toggle()
            }, label: {
                Label("", systemImage: "plus")
            })
        }
        .onAppear {
            viewModel.getCDVaults()
        }
        .sheet(isPresented: $viewModel.isPresented) {
            CreateVaultSheetView(isPresented: $viewModel.isPresented)
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    return NavigationStack {
        VaultListView(path: $path)
    }
}

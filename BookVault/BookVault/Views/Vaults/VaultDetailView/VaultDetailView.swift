//
//  VaultDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.08.24.
//

import SwiftUI

struct VaultDetailView: View {
    @EnvironmentObject var viewModel: VaultDetailViewModel

    var body: some View {
        if viewModel.books.isEmpty && viewModel.notes.isEmpty {
            Text("Weder Bücher noch Notizen in der Vault.")
            Spacer()
        }
        if !viewModel.books.isEmpty {
            Section("Bücher") {
                VaultDetailHorizontalView()
                    .environmentObject(viewModel)
            }
        }
        if !viewModel.notes.isEmpty {
            Section("Notizen") {
                List(viewModel.notes.sorted(by: { $0.title ?? "" < $1.title ?? "" })) { note in
                    NavigationLink(destination: {
                        NoteDetailView()
                            .environmentObject(NoteDetailViewModel(note: note))
                    }, label: {
                        Text(note.title ?? "no title")
                    })
                }
                .navigationTitle(viewModel.vault.name ?? "Vault Details")
            }
        }
    }
}

#Preview("VaultListView") {
    @State var path = NavigationPath()
    return NavigationStack {
        VaultListView(path: $path)
    }
}

//
//  CreateTagView.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 23.07.24.
//

import SwiftUI

struct CreateTagView: View {
    @EnvironmentObject var viewModel: NotesListViewModel

    @State private var tagName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Schlagwort Name", text: $tagName)

                Button("Schlagwort hinzufügen") {
                    viewModel.createTag(tagName)
                    tagName = ""
                    viewModel.isPresented = false
                }
            }
        }
    }
}

#Preview {
    CreateTagView()
        .environmentObject(NotesListViewModel())
}

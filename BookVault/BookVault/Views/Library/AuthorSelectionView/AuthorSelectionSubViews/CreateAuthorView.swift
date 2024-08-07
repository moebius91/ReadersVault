//
//  CreateAuthorView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import SwiftUI

struct CreateAuthorView: View {
    @EnvironmentObject var viewModel: AuthorSelectionViewModel

    @State private var authorName: String = ""
    var body: some View {
        NavigationStack {
            Form {
                TextField("Autoren Name", text: $authorName)

                Button("Autor hinzufügen") {
                    viewModel.createAuthor(authorName)
                    authorName = ""
                    viewModel.isPresented = false
                }
            }
        }
    }
}

#Preview {
    CreateAuthorView()
}

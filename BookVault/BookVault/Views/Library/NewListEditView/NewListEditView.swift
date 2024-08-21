//
//  NewListEditView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 21.08.24.
//

import SwiftUI

struct NewListEditView: View {
    @StateObject private var viewModel = NewListEditViewModel()
    @State private var newListTitle: String = ""

    @Binding var showNewListSheet: Bool
    @Binding var showingAlert: Bool

    var body: some View {
        Form {
            Section("Titel hinzufügen") {
                TextField("Titel der neuen Liste", text: $newListTitle)
                    .padding(8)
            }
            Section("Kategorie hinzufügen") {
                Picker("Kategorie:", selection: $viewModel.category) {
                    Text("Keine Kategorie").tag(nil as CDCategory?)
                    ForEach(viewModel.categories) { category in
                        Text(category.name ?? "no name").tag(category as CDCategory?)
                    }
                }
            }
            Section {
                Button(action: {
                    if !newListTitle.isEmpty {
                        viewModel.createList(newListTitle)
                        newListTitle = ""
                        showNewListSheet = false
                    } else {
                        showingAlert = true
                    }
                }, label: {
                    Text("Liste hinzufügen")
                })
            }
        }
        .onAppear {
            viewModel.getCDCategories()
        }
    }
}

#Preview {
    @State var showNewListSheet = true
    @State var showingAlert = false
    return NewListEditView(showNewListSheet: $showNewListSheet, showingAlert: $showingAlert)
}

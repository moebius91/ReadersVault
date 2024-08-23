//
//  BookListDetailEditView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 21.08.24.
//

import SwiftUI

struct BookListDetailEditView: View {
    @EnvironmentObject var viewModel: BookListDetailViewModel
    @EnvironmentObject var list: CDList

    @Binding var isEditPresented: Bool
    @State private var title: String = ""

    var body: some View {
        Form {
            Section("Titel bearbeiten") {
                TextField(list.title ?? "no title", text: $title)
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
                    if let category = viewModel.category {
                        viewModel.updateList(list, title: title, category: category)
                        isEditPresented.toggle()
                    } else {
                        viewModel.updateList(list, title: title, category: nil)
                        isEditPresented.toggle()
                    }
                }) {
                    Text("Speichern")
                }
            }
        }
        .onAppear {
            viewModel.getCDLists()
            viewModel.category = list.category
            title = list.title ?? "no title"
        }
    }
}

#Preview {
    @State var isEditPresented = false
    let viewModel = BookListDetailViewModel()
    viewModel.getCDLists()

    if let list = viewModel.lists.first {
        return BookListDetailEditView(isEditPresented: $isEditPresented)
            .environmentObject(viewModel)
            .environmentObject(list)
    }

    return EmptyView()
}

//
//  VerticalBookListsView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 11.07.24.
//

import SwiftUI

struct VerticalBookListsView: View {
    @EnvironmentObject var viewModel: LibraryViewModel

    var body: some View {
        Section {
            Button(action: {
                viewModel.showNewListSheet = true
            }, label: {
                Text("Neue Liste")
            })
            .buttonStyle(BorderlessButtonStyle())
            ForEach(viewModel.lists) { list in
                NavigationLink(
                    destination: {
                        BookListDetailView()
                            .environmentObject(BookListDetailViewModel())
                            .environmentObject(list)
                    }
                ) {
                    Text(list.title ?? "no title")
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
            Text("Eigene Listen")
                .bold()
                .font(.title2)
        }
        .padding(0)
    }
}

#Preview {
    NavigationStack {
        VStack(alignment: .leading) {
            let viewModel = LibraryViewModel()
            viewModel.getCDBooks()
            viewModel.getCDLists()

            return VerticalBookListsView()
                .environmentObject(viewModel)
        }
    }
}

#Preview("LibraryView") {
    LibraryView()
}

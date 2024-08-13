//
//  GroupsView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct GroupsView: View {
    @StateObject var loginViewModel = LoginViewModel.shared

    @StateObject var viewModel = GroupsViewModel()

    var body: some View {
        if loginViewModel.isLoggedIn() {
            VStack {
                if viewModel.groups.isEmpty {
                    Spacer()
                    Text("Keine Gruppen vorhanden.")
                }
                List(viewModel.groups) { group in
                    Text(group.name)
                        .swipeActions {
                            Button(role: .destructive, action: {
                                viewModel.deleteGroup(withId: group.id)
                            }, label: {
                                Label("", systemImage: "trash")
                            })
                        }
                }
            }
            .onAppear {
                viewModel.fetchGroups()
            }
            .toolbar {
                Button("", systemImage: "plus") {
                    viewModel.groupName = "Testgruppe"
                    viewModel.createGroup()
                }
            }
        } else {
            Text("Du bist nicht eingeloggt.")
        }
    }
}

#Preview {
    NavigationStack {
        GroupsView()
    }
}

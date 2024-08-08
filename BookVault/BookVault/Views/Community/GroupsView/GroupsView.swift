//
//  GroupsView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct GroupsView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @StateObject var viewModel = GroupsViewModel()

    var body: some View {
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
    }
}

#Preview {
    NavigationStack {
        GroupsView()
    }
}

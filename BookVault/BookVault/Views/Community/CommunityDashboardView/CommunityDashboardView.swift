//
//  CommunityDashboardView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct CommunityDashboardView: View {
    @StateObject var viewModel = CommunityDashboardViewModel()

    var body: some View {
        VStack {
            NavigationLink(destination: {
                GroupsView()
            }) {
                CommunityGroupsView()
            }
            NavigationLink(destination: {
                BulletinBoardView()
            }) {
                CommunityBlackboardView()
            }
            HStack {
                NavigationLink(destination: {
                    MessagesView()
                }) {
                    VStack {
                        Spacer()
                        Image(systemName: "mail")
                            .resizable()
                            .padding()
                            .foregroundStyle(.black)
                            .scaledToFit()
                        Spacer()
                    }
                    .border(.black, width: 2)
                }
                NavigationLink(destination: {
                    ProfileView()
                }) {
                    VStack {
                        Spacer()
                        Image(systemName: "person.fill")
                            .resizable()
                            .padding()
                            .foregroundStyle(.black)
                            .scaledToFit()
                        Spacer()
                    }
                    .border(.black, width: 2)
                }
            }
            .padding(.horizontal)
            .frame(height: 200)
        }
        .navigationTitle("Community")
        .padding(.bottom)
    }
}

#Preview {
    NavigationStack {
        CommunityDashboardView()
    }
}

#Preview("CommunityView") {
    CommunityNavigatorView()
}

#Preview("Navi") {
    NavigatorView()
}

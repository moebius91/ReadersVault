//
//  CommunityDashboardView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct CommunityDashboardView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    @StateObject var viewModel = CommunityDashboardViewModel()

    var body: some View {
        VStack {
            NavigationLink(destination: {
                GroupsView()
                    .environmentObject(loginViewModel)
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
                        .environmentObject(loginViewModel)
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
            .environmentObject(LoginViewModel())
    }
}

#Preview("CommunityView") {
    CommunityNavigatorView()
}

#Preview("Navi") {
    NavigatorView()
}

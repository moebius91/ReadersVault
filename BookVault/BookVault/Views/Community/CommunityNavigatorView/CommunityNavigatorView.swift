//
//  CommunityNavigatorView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct CommunityNavigatorView: View {
    @StateObject private var viewModel = LoginViewModel.shared

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.isLoggedIn() {
                case true:
                    if !viewModel.isEmailVerified {
                        VerificationPendingView()
                    } else {
                        CommunityDashboardView()
                    }
                case false:
                    LoginView()
                        .environmentObject(viewModel)
                }
            }
            .onChange(of: viewModel.isEmailVerified) { newValue, _ in
                if !newValue {
                    viewModel.checkEmailVerificationStatus()
                }
            }
        }
    }
}

#Preview {
    CommunityNavigatorView()
}

#Preview("Navi") {
    NavigatorView()
}

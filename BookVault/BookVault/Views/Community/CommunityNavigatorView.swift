//
//  CommunityNavigatorView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct CommunityNavigatorView: View {
    @StateObject private var viewModel: LoginViewModel = .init()

    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.user != nil {
                case true:
                    if !viewModel.isEmailVerified {
                        VerificationPendingView()
                            .environmentObject(viewModel)
                    } else {
                        CommunityDashboardView()
                            .environmentObject(viewModel)
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

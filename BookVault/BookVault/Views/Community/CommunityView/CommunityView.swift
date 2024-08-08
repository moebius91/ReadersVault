//
//  CommunityView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 05.07.24.
//

import SwiftUI

struct CommunityView: View {
    @StateObject private var viewModel: LoginViewModel = .init()

    var body: some View {
        VStack {
            switch viewModel.user != nil {
            case true:
                if !viewModel.isEmailVerified {
                    VerificationPendingView()
                        .environmentObject(viewModel)
                } else {
                    Text("Bist angemeldet")
                    Button("Ausloggen.") {
                        viewModel.logout()
                    }
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

#Preview {
    CommunityView()
}

#Preview("Navi") {
    NavigatorView()
}

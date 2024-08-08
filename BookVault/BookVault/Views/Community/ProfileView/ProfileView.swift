//
//  ProfileView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        Text("Profile")
            .navigationTitle("Profil")
        Button("Ausloggen") {
            loginViewModel.logout()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}

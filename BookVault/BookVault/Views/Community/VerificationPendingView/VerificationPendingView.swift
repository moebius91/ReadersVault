//
//  VerificationPendingView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 07.08.24.
//

import SwiftUI
import FirebaseAuth

struct VerificationPendingView: View {
    @StateObject var viewModel = LoginViewModel.shared

    var body: some View {
        VStack {
            Text("Ihre E-Mail-Adresse muss noch bestätigt werden.")
                .padding()
            if let message = viewModel.verificationMessage {
                Text(message)
                    .padding()
            }
            Button("Erneut senden") {
                if let user = Auth.auth().currentUser {
                    user.sendEmailVerification { error in
                        if let error = error {
                            print("Fehler beim erneuten Senden der Bestätigungs-E-Mail: \(error)")
                        } else {
                            viewModel.setVerificationMessage("Bestätigungs-E-Mail erneut gesendet.")
                        }
                    }
                }
            }
            .padding()

            Button("E-Mail-Verifizierung überprüfen") {
                if let user = Auth.auth().currentUser {
                    user.reload { error in
                        if let error = error {
                            print("Fehler beim Neuladen des Benutzers: \(error)")
                            return
                        }
                        viewModel.checkEmailVerificationStatus()
                        if user.isEmailVerified {
                            viewModel.setVerificationMessage("E-Mail erfolgreich verifiziert.")
                        } else {
                            viewModel.setVerificationMessage("E-Mail ist noch nicht verifiziert.")
                        }
                    }
                }
            }
            .padding()

            Divider()

            Button("Ausloggen") {
                viewModel.logout()
            }
            .padding()
            .buttonStyle(BorderedButtonStyle())
        }
    }
}

#Preview {
    VerificationPendingView()
//        .environmentObject(LoginViewModel.shared)
}

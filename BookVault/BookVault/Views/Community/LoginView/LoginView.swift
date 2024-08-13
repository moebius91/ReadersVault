//
//  LoginView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 07.08.24.
//

import SwiftUI

struct LoginView: View {
    fileprivate enum Mode {
        case registration, login

        var mainButtonText: String {
            switch self {
            case .registration:
                "Registrieren"
            case .login:
                "Anmelden"
            }
        }

        var alternativeButtonText: String {
            switch self {
            case .registration:
                "Hast du schon einen Account?\nZur Anmeldung"
            case .login:
                "Noch kein Account?\nJetzt Registrieren!"
            }
        }

        mutating func toggle() {
            switch self {
            case .registration:
                self = .login
            case .login:
                self = .registration
            }
        }
    }

    @EnvironmentObject private var viewModel: LoginViewModel

    @State private var hidePassword: Bool = true
    @State private var mode: Mode = .login

    var body: some View {
        VStack {
            VStack {
                HStack {
                    // Bulletpoints statt Logo
                    Spacer()
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250)
                        .foregroundStyle(.gray)
                    Spacer()
                }
                .padding(.top)
            }
            .padding()

            VStack {
                TextField("E-Mail-Adresse", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()

                if case .registration = mode {
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .padding(.horizontal)
                        .padding(.bottom)
                }

                HStack {
                    if hidePassword {
                        SecureField("Passwort", text: $viewModel.password)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        TextField("Passwort", text: $viewModel.password)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                    }
                    Button("", systemImage: hidePassword ? "eye" : "eye.slash") {
                        hidePassword.toggle()
                    }
                }.padding(.horizontal)

                if case .registration = mode {
                    if hidePassword {
                        SecureField("Passwort (Wiederholung)", text: $viewModel.passwordCheck)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    } else {
                        TextField("Passwort (Wiederholung)", text: $viewModel.passwordCheck)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .padding(.top, 8)
                    }
                }

                Button(mode.mainButtonText) {
                    switch mode {
                    case .registration:
                        viewModel.register()
                    case .login:
                        viewModel.login()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .padding()

                if let usernameError = viewModel.usernameError {
                    Text(usernameError)
                        .foregroundStyle(.red)
                        .padding()
                }

                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundStyle(.red)
                        .padding()
                }

                if let commonError = viewModel.commonError {
                    Text(commonError)
                        .foregroundStyle(.red)
                        .padding()
                }

                Divider().padding()

                Button(mode.alternativeButtonText) {
                    withAnimation(.none) {
                        mode.toggle()
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel.shared)
}

#Preview("Navi") {
    NavigatorView()
}

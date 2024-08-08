//
//  LoginViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 07.08.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""

    @Published private(set) var user: FireUser?
    @Published private(set) var passwordError: String?
    @Published private(set) var usernameError: String?
    @Published private(set) var commonError: String?
    @Published private(set) var verificationMessage: String?
    @Published private(set) var isEmailVerified: Bool = false

    private let firebaseAuthenticaiton = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()

    init() {
        if let currentUser = self.firebaseAuthenticaiton.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
            self.isEmailVerified = currentUser.isEmailVerified
            self.checkEmailVerificationStatus()
        }
    }

    func login() {
        if self.email.isEmpty {
            print("E-Mail darf nicht leer sein!")
            self.commonError = "E-Mail darf nicht leer sein!"
            return
        } else {
            self.commonError = nil
        }

        if self.password.isEmpty {
            print("Passwort darf nicht leer sein!")
            self.passwordError = "Passwort darf nicht leer sein!"
            return
        } else {
            self.passwordError = nil
        }

        firebaseAuthenticaiton.signIn(withEmail: self.email, password: self.password) { authResult, error in
            if let error {
                print("Error in login: \(error)")
                self.commonError = "Fehler beim Anmelden"
                return
            }

            guard let authResult, let userEmail = authResult.user.email else {
                print("authResult oder E-Mail sind leer!")
                return
            }

            self.isEmailVerified = authResult.user.isEmailVerified

            guard self.isEmailVerified else {
                self.verificationMessage = "Bitte bestätitgen Sie Ihre E-Mail-Adresse"
                print("Bitte bestätigen Sie Ihre E-Mail-Adresse.")
                return
            }

            print("Erfolgreich eingeloggt mit Benutzer-ID \(authResult.user.uid) und E-Mail \(userEmail)")

            self.fetchFirestoreUser(withId: authResult.user.uid)
        }
    }

    func register() {
        if self.email.isEmpty {
            print("E-Mail darf nicht leer sein!")
            self.commonError = "E-Mail darf nicht leer sein!"
            return
        } else {
            self.commonError = nil
        }

        if self.username.isEmpty {
            print("Benutzername darf nicht leer sein!")
            self.usernameError = "Benutzername darf nicht leer sein!"
            return
        } else {
            self.usernameError = nil
        }

        if self.password.isEmpty {
            print("Passwort darf nicht leer sein!")
            self.passwordError = "Passwort darf nicht leer sein!"
            return
        } else {
            self.passwordError = nil
        }

        if self.passwordCheck.isEmpty {
            print("Passwort (Wiederholung) darf nicht leer sein!")
            self.passwordError = "Passwort (Wiederholung) darf nicht leer sein!"
            return
        } else {
            self.passwordError = nil
        }

        guard self.password == self.passwordCheck else {
            self.passwordError = "Passwörter stimmen nicht überein!"
            return
        }

        let username = self.username.trimmingCharacters(in: .whitespacesAndNewlines)

        firebaseFirestore.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if let error = error {
                print("Fehler beim Überprüfen des Benutzernamens: \(error.localizedDescription)")
                return
            }

            if snapshot?.isEmpty == false {
                print("Benutzername ist bereits vergeben.")
                self.usernameError = "Benutzername ist bereits vergeben!"
                return
            }

            self.firebaseAuthenticaiton.createUser(withEmail: self.email, password: self.password) { authResult, error in
                if let error {
                    print("Fehler beim Registrieren: \(error)")
                    self.commonError = "Fehler beim Registrieren.\nVersuchen Sie es später noch einmal."
                    return
                }

                guard let authResult, let userEmail = authResult.user.email else {
                    print("authResult oder E-Mail sind leer!")
                    return
                }

                self.createFirestoreUser(id: authResult.user.uid)

                authResult.user.sendEmailVerification { error in
                    if let error {
                        print("Fehler beim Senden der Bestätigungs-E-Mail: \(error)")
                        self.commonError = "Fehler beim Senden der Bestätigungs-E-Mail.\nVersuchen Sie es später noch einmal."
                        return
                    }

                    print("Bestätigungs-E-Mail gesendet.")
                    self.verificationMessage = "Eine Bestätigungs-E-Mail wurde an \(userEmail) gesendet.\nBitte überprüfen Sie Ihre E-Mails."
                }

                print("Erfolgreich registriert mit Benutzer-ID \(authResult.user.uid) und E-Mail \(userEmail)")

                self.fetchFirestoreUser(withId: authResult.user.uid)
            }
        }
    }

    func logout() {
        do {
            try firebaseAuthenticaiton.signOut()
            self.user = nil
        } catch {
            print("Fehler beim ausloggen: \(error)")
        }
    }

    func setVerificationMessage(_ message: String) {
        self.verificationMessage = message
    }

    func checkEmailVerificationStatus() {
        guard let user = firebaseAuthenticaiton.currentUser else {
            return
        }

        user.reload { error in
            if let error {
                print("Fehler beim Neuladen des Benutzers: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.isEmailVerified = user.isEmailVerified
            }
        }
    }

    private func createFirestoreUser(id: String) {
        let newFireUser = FireUser(id: id, email: self.email, username: self.username, registeredAt: Date())

        do {
            try self.firebaseFirestore.collection("users").document(id).setData(from: newFireUser)
        } catch {
            print("Fehler beim Speichern des Benutzers in Firestore: \(error)")
        }
    }

    private func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Fehler beim Abrufen des Benutzers: \(error)")
                return
            }

            guard let document else {
                print("Dokument existiert nicht.")
                return
            }

            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Benutzer konnte nicht dekodiert werden: \(error)")
            }
        }
    }
}

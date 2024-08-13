//
//  GroupsViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class GroupsViewModel: ObservableObject {
    @Published var groups: [FireGroup] = []

    @Published var groupName: String = ""

    private var user: FireUser?

    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    private var listener: ListenerRegistration?

    private let collectionName = "groups"

    init() {
        if let currentUser = self.firebaseAuthentication.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
        }
    }

    func createGroup() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

        var newFireGroup = FireGroup(name: self.groupName, creatorId: userId, createdAt: Date())

        if let user = self.user {
            newFireGroup.userlist.append(user)
        }

        do {
            try self.firebaseFirestore.collection(self.collectionName).addDocument(from: newFireGroup)
        } catch {
            print(error)
        }
    }

    func fetchGroups() {
        self.listener = self.firebaseFirestore.collection(self.collectionName)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Fehler beim Laden der Gruppen: \(error)")
                    return
                }

                guard let snapshot else {
                    print("Snapshot ist leer")
                    return
                }

                let groups = snapshot.documents.compactMap { document -> FireGroup? in
                    do {
                        return try document.data(as: FireGroup.self)
                    } catch {
                        print(error)
                    }
                    return nil
                }

                self.groups = groups
            }
    }

    func deleteGroup(withId id: String?) {
        guard let id else {
            print("Gruppe hat keine ID!")
            return
        }

        firebaseFirestore.collection(self.collectionName).document(id).delete { error in
            if let error {
                print("Löschen fehlgeschlagen: \(error)")
            }
        }
    }

    private func fetchFirestoreUser(withId id: String) {
        self.firebaseFirestore.collection("users").document(id).getDocument { document, error in
            if let error {
                print("Error fetching user: \(error)")
                return
            }

            guard let document else {
                print("Document does not exist")
                return
            }

            do {
                let user = try document.data(as: FireUser.self)
                self.user = user
            } catch {
                print("Could not decode user: \(error)")
            }
        }
    }
}

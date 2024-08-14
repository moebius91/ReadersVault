//
//  BulletinBoardViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class BulletinBoardViewModel: ObservableObject {
    @Published var posts: [FireBulletinBoardPost] = []
    @Published var isPresented: Bool = false
    @Published var postTitle: String = ""
    @Published var postContent: String = ""

    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    private var listener: ListenerRegistration?

    private let collectionName = "bulletboardposts"

    func createPost() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

        let newFireBulletinBoardPost = FireBulletinBoardPost(title: self.postTitle, content: self.postContent, userId: userId, timestamp: Date())

        do {
            try self.firebaseFirestore.collection(self.collectionName).addDocument(from: newFireBulletinBoardPost)
        } catch {
            print(error)
        }
    }

    func fetchPosts() {
        self.listener = self.firebaseFirestore.collection(collectionName)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Fehler beim Laden der Posts: \(error)")
                    return
                }

                guard let snapshot else {
                    print("Snapshot ist leer")
                    return
                }

                let posts = snapshot.documents.compactMap { document -> FireBulletinBoardPost? in
                    do {
                        return try document.data(as: FireBulletinBoardPost.self)
                    } catch {
                        print(error)
                    }
                    return nil
                }

                self.posts = posts
            }
    }

    func deletePost(withId id: String?) {
        guard let id else {
            print("Post hat keine ID!")
            return
        }

        firebaseFirestore.collection(self.collectionName).document(id).delete { error in
            if let error {
                print("Löschen fehlgeschlagen: \(error)")
            }
        }
    }
}

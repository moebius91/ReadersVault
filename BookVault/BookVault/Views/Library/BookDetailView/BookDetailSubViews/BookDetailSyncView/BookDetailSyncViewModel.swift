//
//  BookDetailSyncViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 13.08.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class BookDetailSyncViewModel: ObservableObject {
    @Published var book: CDBook
    @Published var isBookSynced: Bool = false

    private var fireBook: FireBook?

    private var user: FireUser?

    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    private var listener: ListenerRegistration?

    private let collectionName = "books"

    init(book: CDBook) {
        self.book = book
        if let currentUser = self.firebaseAuthentication.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
            self.fetchBook()
        }
    }

    deinit {
        self.listener?.remove()
    }

    func createBook() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

        let newFireBook = cdBookToFireBook()

        do {
            try self.firebaseFirestore.collection("users").document(userId).collection(self.collectionName).addDocument(from: newFireBook) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    self.isBookSynced = true  // Buch wurde erfolgreich synchronisiert
                }
            }
        } catch {
            print(error)
        }
    }

    func fetchBook() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

//        guard let bookId = self.book.id?.uuidString else {
//            print("Book-ID leer.")
//            return
//        }

        guard let isbn13 = self.book.isbn13 else {
            print("ISBN13 leer.")
            return
        }

        self.listener = self.firebaseFirestore.collection("users").document(userId).collection(collectionName)
            .whereField("isbn13", isEqualTo: isbn13)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Fehler beim Laden des Buches: \(error)")
                    return
                }

                guard let snapshot else {
                    print("Snapshot ist leer")
                    return
                }

                let fireBook = snapshot.documents.compactMap { document -> FireBook? in
                    do {
                        return try document.data(as: FireBook.self)
                    } catch {
                        print(error)
                    }
                    return nil
                }

                self.fireBook = fireBook.first
                self.isBookSynced = self.fireBook?.isbn13 == self.book.isbn13
            }
    }

    func deleteBook(withISBN13 isbn13: String) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

        // Suchen des Dokuments basierend auf ISBN13
        let collectionRef = firebaseFirestore.collection("users").document(userId).collection(collectionName)
        collectionRef.whereField("isbn13", isEqualTo: isbn13).getDocuments { querySnapshot, error in
            if let error = error {
                print("Fehler beim Abrufen der Dokumente: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("Kein Dokument gefunden.")
                return
            }

            // Löschen des ersten gefundenen Dokuments (sollte in der Regel nur eines sein)
            let documentID = documents.first?.documentID

            collectionRef.document(documentID!).delete { error in
                if let error = error {
                    print("Löschen fehlgeschlagen: \(error)")
                } else {
                    print("Dokument erfolgreich gelöscht.")
                    self.isBookSynced = false
                }
            }
            self.fireBook = nil
        }
    }


//    func deleteBook(withId id: String?) {
//        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
//            print("Benutzer ist nicht angemeldet.")
//            return
//        }
//
//        guard let id else {
//            print("Item hat keine ID!")
//            return
//        }
//
//        firebaseFirestore.collection("users").document(userId).collection(collectionName).document(id).delete() { error in
//            if let error {
//                print("Löschen fehlgeschlagen: \(error)")
//            }
//            print("Dokument id: \(id)")
//        }
//    }

    private func cdBookToFireBook() -> FireBook {
        let fireBook = FireBook(
            id: self.book.id?.uuidString ?? "",
            isbn: self.book.isbn ?? "",
            isbn10: self.book.isbn10 ?? "",
            isbn13: self.book.isbn13 ?? "",
            isFavorite: self.book.isFavorite,
            isDesired: self.book.isDesired,
            isRead: self.book.isRead,
            isLoaned: self.book.isLoaned,
            isOwned: self.book.isOwned,
            publisher: self.book.publisher ?? "",
            shortDescription: self.book.short_description ?? "",
            title: self.book.title ?? "",
            titleLong: self.book.title_long ?? "",
            coverImage: Data(),
            coverUrl: self.book.coverUrl ?? URL(string: "https://nocov.er")!
        )

        return fireBook
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

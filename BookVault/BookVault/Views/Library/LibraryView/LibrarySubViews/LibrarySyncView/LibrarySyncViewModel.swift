//
//  LibrarySyncViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 14.08.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LibrarySyncViewModel: ObservableObject {
    @Published var books: [FireBook] = []
    @Published var filteredBooks: [FireBook] = []

    private let cdBooks: [CDBook]

    private var user: FireUser?

    private let firebaseAuthentication = Auth.auth()
    private let firebaseFirestore = Firestore.firestore()
    private var listener: ListenerRegistration?

    private let collectionName = "books"

    init(books: [CDBook]) {
        self.cdBooks = books
        if let currentUser = self.firebaseAuthentication.currentUser {
            self.fetchFirestoreUser(withId: currentUser.uid)
            self.fetchBooks()
        }
    }

    deinit {
        self.listener?.remove()
    }

    func syncFireBookToCoreData(fireBook: FireBook) {
        let cdBook = CDBook(context: PersistentStore.shared.context)
        cdBook.id = UUID()
        cdBook.title = fireBook.title
        cdBook.coverUrl = fireBook.coverUrl
        cdBook.isbn = fireBook.isbn
        cdBook.isbn10 = fireBook.isbn10
        cdBook.isbn13 = fireBook.isbn13
        cdBook.publisher = fireBook.publisher
        cdBook.isRead = fireBook.isRead
        cdBook.isDesired = fireBook.isDesired
        cdBook.isLoaned = fireBook.isLoaned
        cdBook.isOwned = fireBook.isOwned

        downloadImage(from: fireBook.coverUrl) { data in
            cdBook.coverImage = data
            PersistentStore.shared.save()
        }
    }

    func fetchBooks() {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

        self.listener = self.firebaseFirestore.collection("users").document(userId).collection(collectionName)
            .addSnapshotListener { snapshot, error in
                if let error {
                    print("Fehler beim Laden des Buches: \(error)")
                    return
                }

                guard let snapshot else {
                    print("Snapshot ist leer")
                    return
                }

                let books = snapshot.documents.compactMap { document -> FireBook? in
                    do {
                        return try document.data(as: FireBook.self)
                    } catch {
                        print(error)
                    }
                    return nil
                }

                self.books = books
                self.filterBooksByISBN13()
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

    private func filterBooksByISBN13() {
        let cdBooksISBNSet = Set(cdBooks.map { $0.isbn13 })
        self.filteredBooks = self.books.filter { !cdBooksISBNSet.contains($0.isbn13) }
    }

    private func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    completion(data)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        .resume()
    }
}

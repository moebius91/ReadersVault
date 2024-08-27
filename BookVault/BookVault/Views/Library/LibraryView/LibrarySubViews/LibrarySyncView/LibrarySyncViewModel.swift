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
    @Published var fireBaseOnlyBooks: [FireBook] = []
    @Published var localOnlyBooks: [CDBook] = []

    @Published var syncedBooks: [FireBook] = []

    private var cdBooks: [CDBook]

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
            self.getLocalOnlyBooks()
            self.getAllSyncedBooks()
        }
    }

    deinit {
        self.listener?.remove()
    }

    func start() {
        self.fetchBooks()
        self.getLocalOnlyBooks()
        self.getAllSyncedBooks()
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
        cdBook.createdAt = Date()

        downloadImage(from: fireBook.coverUrl) { data in
            cdBook.coverImage = data
            PersistentStore.shared.save()

            self.getCDBooks()
            self.fetchBooks()
            self.getLocalOnlyBooks()
            self.getAllSyncedBooks()
        }
    }

    func syncCoreDataToFireBook(_ book: CDBook) {
        guard let userId = self.firebaseAuthentication.currentUser?.uid else {
            print("Benutzer ist nicht angemeldet.")
            return
        }

        let newFireBook = cdBookToFireBook(book)

        do {
            try self.firebaseFirestore.collection("users").document(userId).collection(self.collectionName).addDocument(from: newFireBook) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    self.fetchBooks()
                    self.getLocalOnlyBooks()
                    self.getAllSyncedBooks()
                }
            }
        } catch {
            print(error)
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

    private func cdBookToFireBook(_ book: CDBook) -> FireBook {
        let fireBook = FireBook(
            id: book.id?.uuidString ?? "",
            isbn: book.isbn ?? "",
            isbn10: book.isbn10 ?? "",
            isbn13: book.isbn13 ?? "",
            isFavorite: book.isFavorite,
            isDesired: book.isDesired,
            isRead: book.isRead,
            isLoaned: book.isLoaned,
            isOwned: book.isOwned,
            publisher: book.publisher ?? "",
            shortDescription: book.short_description ?? "",
            title: book.title ?? "",
            titleLong: book.title_long ?? "",
            coverImage: Data(),
            coverUrl: book.coverUrl ?? URL(string: "https://nocov.er")!
        )

        return fireBook
    }

    private func getLocalOnlyBooks() {
        let fireBookISBNSet = Set(books.map { $0.isbn13 })
        self.localOnlyBooks = self.cdBooks.filter { cdBook in
            guard let isbn13 = cdBook.isbn13 else { return false }
            return !fireBookISBNSet.contains(isbn13)
        }
    }

    private func filterBooksByISBN13() {
        let cdBooksISBNSet = Set(cdBooks.map { $0.isbn13 })
        self.fireBaseOnlyBooks = self.books.filter { !cdBooksISBNSet.contains($0.isbn13) }
    }

    private func getAllSyncedBooks() {
        let cdBooksISBNSet = Set(cdBooks.map { $0.isbn13 })
        self.syncedBooks = self.books.filter {
            cdBooksISBNSet.contains($0.isbn13)
        }

//        let fireBookISBNSet = Set(books.map { $0.isbn13 })
//        self.syncedBooks = self.cdBooks.filter { cdBook in
//            guard let isbn13 = cdBook.isbn13 else { return false }
//            return fireBookISBNSet.contains(isbn13)
//        }
    }

    private func getCDBooks() {
        let fetchRequest = CDBook.fetchRequest()

        do {
            self.cdBooks = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
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

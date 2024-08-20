//
//  BookDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 19.07.24.
//

import SwiftUI

struct BookDetailView: View {
    @StateObject var viewModel: BookDetailViewModel
    @StateObject var syncViewModel: BookDetailSyncViewModel
    @StateObject var loginViewModel = LoginViewModel.shared
    @StateObject var notesViewModel = NotesListViewModel()

    @State var path = NavigationPath()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(viewModel.title)) {
                    HStack {
                        Spacer()
                        if let imageData = viewModel.coverImage, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                .clipped()
                        } else {
                            AsyncImage(
                                url: viewModel.coverUrl,
                                content: { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                },
                                placeholder: {
                                    Image(systemName: "photo.artframe")
                                }
                            )
                            .frame(width: 150)
                        }
                        Spacer()
                    }
                    .padding(.top, 8)
                    VStack(alignment: .leading) {
                        Text(viewModel.title)
                            .font(.title2)
                            .bold()
                        HStack {
                            Text("Publisher: ")
                                .bold()
                                .font(.subheadline)
                                .padding(.top, 2)
                            Text(viewModel.publisher)
                                .font(.subheadline)
                                .padding(.top, 2)
                        }
                        Spacer()
                        HStack {
                            Text("ISBN: ")
                                .bold()
                                .font(.subheadline)
                            Text(viewModel.isbn)
                                .font(.subheadline)
                        }
                        HStack {
                            Text("ISBN-10: ")
                                .bold()
                                .font(.subheadline)
                            Text("\(viewModel.isbn10 == "")")
                                .font(.subheadline)
                        }
                        HStack {
                            Text("ISBN-13: ")
                                .bold()
                                .font(.subheadline)
                            Text(viewModel.isbn13)
                                .font(.subheadline)
                        }
                        Spacer()
                        HStack {
                            HStack {
                                Image(systemName: viewModel.isFavorite ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.isFavorite ? .green : .gray)
                                Text("Favorit")
                            }
                            Spacer()
                            HStack {
                                Text("Gelesen")
                                Image(systemName: viewModel.isRead ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.isRead ? .green : .gray)
                            }
                        }

                        HStack {
                            HStack {
                                Image(systemName: viewModel.isOwned ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(viewModel.isOwned ? .green : .gray)
                                Text("Im Besitz")
                            }
                            Spacer()
                            HStack {
                                if (!viewModel.isOwned && !viewModel.isLoaned) || (viewModel.isOwned && !viewModel.isLoaned) {
                                    // Nichts anzuzeigen
                                } else {
                                    if !viewModel.isOwned && viewModel.isLoaned {
                                        Text("Verliehen")
                                    } else if viewModel.isOwned && viewModel.isLoaned {
                                        Text("Geliehen")
                                    }
                                    Image(systemName: viewModel.isLoaned ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(viewModel.isLoaned ? .green : .gray)
                                }
                            }
                        }

                        if !viewModel.shortDescription.isEmpty {
                            Text("Beschreibung")
                                .font(.headline)
                                .padding(.top, 5)

                            Text(viewModel.shortDescription)
                                .font(.body)
                                .padding(.bottom, 5)
                        }

                        if !viewModel.titleLong.isEmpty {
                            Text("Long Title")
                                .font(.headline)

                            Text(viewModel.titleLong)
                                .font(.body)
                        }
                    }
                    .padding(.bottom, 8)
                }
                if !viewModel.lists.isEmpty {
                    Section(header: Text("Listen")) {
                        List(viewModel.lists) { list in
                            NavigationLink(destination: {
                                BookListDetailView()
                                    .environmentObject(BookListDetailViewModel())
                                    .environmentObject(list)
                            }, label: {
                                Text(list.title ?? "no name")
                            })
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    viewModel.removeBookFromList(list)
                                }) {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                if !viewModel.notes.isEmpty {
                    Section(header: Text("Notizen")) {
                        List(viewModel.notes) { note in
                            NavigationLink(destination: {
                                NoteDetailView()
                                    .environmentObject(NoteDetailViewModel(note: note))
                            }) {
                                Text(note.title ?? "no name")
                            }
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    viewModel.removeNote(note)
                                }) {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                if !viewModel.tags.isEmpty {
                    Section(header: Text("Schlagworte")) {
                        List(viewModel.tags) { tag in
                            VStack {
                                Text(tag.name ?? "no name")
                            }
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    viewModel.removeTag(tag)
                                }) {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                if !viewModel.categories.isEmpty {
                    Section(header: Text("Kategorien")) {
                        List(viewModel.categories) { category in
                            VStack {
                                Text(category.name ?? "no name")
                            }
                            .swipeActions {
                                Button(role: .destructive, action: {
                                    viewModel.removeCategory(category)
                                }) {
                                    Label("Löschen", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Buchdetails")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        viewModel.isListSheetShown = true
                    }, label: {
                        Label("", systemImage: "text.badge.plus")
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if loginViewModel.isLoggedIn() {
                        if !syncViewModel.isBookSynced {
                            Button(action: {
                                viewModel.isSyncSheetShown = true
                            }, label: {
                                Label("Bearbeiten", systemImage: "arrow.triangle.2.circlepath")
                            })
                            .tint(.blue)
                        } else {
                            Button(action: {
                                viewModel.isAlertShown = true
                            }, label: {
                                Label("Bearbeiten", systemImage: "xmark.circle")
                            })
                            .tint(.red)
                        }
                    }
                    Button(action: {
                        viewModel.isEditSheetShown = true
                    }, label: {
                        Label("Bearbeiten", systemImage: "pencil")
                    })
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: {
                        notesViewModel.book = viewModel.book
                        viewModel.isNoteSheetShown = true
                    }, label: {
                        Text("Notiz hinzufügen")
                    })
                }
            }
            .sheet(isPresented: $viewModel.isListSheetShown, onDismiss: {
                viewModel.getListsForBook()
            }) {
                BookToListView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $viewModel.isEditSheetShown) {
                BookDetailEditView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $viewModel.isSyncSheetShown) {
                BookDetailSyncView(isSyncSheetShown: $viewModel.isSyncSheetShown)
                    .environmentObject(syncViewModel)
                    .padding()
                Spacer()
            }
            .sheet(isPresented: $viewModel.isNoteSheetShown) {
                BookNewNoteView()
                    .environmentObject(viewModel)
            }
            .alert("Backup löschen?", isPresented: $viewModel.isAlertShown) {
                Button(role: .destructive, action: {
                    syncViewModel.deleteBook(withISBN13: viewModel.book.isbn13 ?? "")
                }) {
                    Label("Löschen", systemImage: "xmark")
                }
            }
        }
        .onAppear {
            syncViewModel.fetchBook()
        }
    }
}

#Preview {
    let libraryViewModel = LibraryViewModel()
    libraryViewModel.getCDBooks()

    let book = libraryViewModel.books.first

    guard book != nil else {
        return VStack {
            Text("Diesen Text solltest Du eigentlich nicht sehen.")
            Text("Ein Fehler ist aufgetreten.")
        }
    }

    let viewModel = BookDetailViewModel(book: book!)
    let syncViewModel = BookDetailSyncViewModel(book: book!)

    return BookDetailView(viewModel: viewModel, syncViewModel: syncViewModel)
}

#Preview("Navi") {
    NavigatorView()
}

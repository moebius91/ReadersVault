//
//  NoteDetailViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import Foundation

class NoteDetailViewModel: ObservableObject {
    @Published var note: CDNote

    @Published var editTitle = ""
    @Published var editContent = ""

    init(note: CDNote) {
        self.note = note
    }

    func getNoteFromDB() {
        let fetchRequest = CDNote.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id = %@", note.id! as any CVarArg)

        do {
            self.note = try PersistentStore.shared.context.fetch(fetchRequest).first ?? CDNote()
        } catch {
            return
        }
    }

    func updateNote() {
        note.title = self.editTitle
        note.content = self.editContent

        PersistentStore.shared.save()
        
        self.editTitle = ""
        self.editContent = ""
    }
}

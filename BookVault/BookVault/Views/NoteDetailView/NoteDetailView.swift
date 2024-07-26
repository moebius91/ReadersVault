//
//  NoteDetailView.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 24.07.24.
//

import SwiftUI

struct NoteDetailView: View {
    var note: CDNote

    @State private var isSheetShown = false

    var body: some View {
        Section {
            Text("NoteDetailView")
            //            Spacer()
                .toolbar {
                    Button(action: {
                        isSheetShown = true
                    }, label: {
                        Label("Bearbeiten", systemImage: "pencil")
                    })
                }
        }
        .sheet(isPresented: $isSheetShown) {
            Button(action: {
                isSheetShown = false
            }, label: {
                Text("Schließen")
            })
        }
        .navigationTitle(note.title ?? "no title")
    }
}

#Preview {
    let fetchRequest = CDNote.fetchRequest()
    var note: CDNote = CDNote()

    do {
        note = try PersistentStore.shared.context.fetch(fetchRequest).first!
    } catch {
        return TestView()
    }

    return NavigationStack {
        NoteDetailView(note: note)
    }
}

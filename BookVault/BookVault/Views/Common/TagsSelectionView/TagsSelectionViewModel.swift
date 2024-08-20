//
//  TagsSelectionViewModel.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 28.07.24.
//

import Foundation

class TagsSelectionViewModel: ObservableObject {
    @Published var tags: [CDTag] = []

    @Published var isPresented: Bool = false
    @Published var searchText: String = ""

    var filteredTags: [CDTag] {
        if searchText.isEmpty {
            return tags
        } else {
            return tags.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    func getCDTags() {
        let fetchRequest = CDTag.fetchRequest()

        do {
            self.tags = try PersistentStore.shared.context.fetch(fetchRequest)
        } catch {
            return
        }
    }

    func createTag(_ name: String) {
        let cdTag = CDTag(context: PersistentStore.shared.context)
        cdTag.id = UUID()
        cdTag.name = name

        saveAndFetchTags()
    }

    private func saveAndFetchTags() {
        PersistentStore.shared.save()
        getCDTags()
    }
}

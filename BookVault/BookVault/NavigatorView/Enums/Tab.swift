//
//  Tab.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

// Entnommen einer Tagesaufgabe
enum Tab: String, Identifiable, CaseIterable {
    case home, booklists, search, community, notes
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Startseite"
        case .booklists: return "Bibliothek"
        case .search: return "Suche"
        case .community: return "Community"
        case .notes: return "Notizen"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .booklists: return "books.vertical"
        case .search: return "magnifyingglass"
        case .community: return "person.2.fill"
        case .notes: return "list.clipboard"
        }
    }
    
    var view: AnyView {
        switch self {
        case .home: return AnyView(HomeView())
        case .booklists: return AnyView(BookListView())
        case .search: return AnyView(SearchView())
        case .community: return AnyView(CommunityView())
        case .notes: return AnyView(NotesListView())
        }
    }
}

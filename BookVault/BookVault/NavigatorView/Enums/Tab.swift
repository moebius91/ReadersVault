//
//  Tab.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI

// Entnommen einer Tagesaufgabe
enum Tab: String, Identifiable, CaseIterable {
    case home, booklists, search, notes, settings
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Startseite"
        case .booklists: return "Bibliothek"
        case .search: return "Suche"
        case .notes: return "Community"
        case .settings: return "Einstellungen"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .booklists: return "books.vertical"
        case .search: return "magnifyingglass"
        case .notes: return "person.2.fill"
        case .settings: return "gear"
        }
    }
    
    var view: AnyView {
        switch self {
        case .home: return AnyView(HomeView())
        case .booklists: return AnyView(BookListView())
        case .search: return AnyView(SearchView())
        case .notes: return AnyView(CommunityView())
        case .settings: return AnyView(SettingsView())
        }
    }
}

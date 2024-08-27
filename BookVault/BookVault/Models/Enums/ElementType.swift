//
//  ElementType.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 23.08.24.
//

import Foundation

enum ElementType: String, Codable, CaseIterable {
    case standard = "Standard"
    case book = "Buch"
    case books = "Bücher"
    case stats = "Statistiken"
    case list = "Liste"
    case lists = "Listen"
    case favs = "Favoriten"
    case addedLast = "Zuletzt hinzugefügt"
}

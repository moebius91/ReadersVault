//
//  WidgetBook.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import Foundation

struct WidgetBook: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var cdBookId: UUID
    var title: String
    var cover: Data?
}

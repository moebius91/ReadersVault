//
//  WidgetList.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import Foundation

struct WidgetList: Identifiable, Codable, Equatable {
    var id = UUID()
    var cdListId: UUID
    var title: String
    var books: [WidgetBook]
}

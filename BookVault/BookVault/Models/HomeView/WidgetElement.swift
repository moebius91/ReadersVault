//
//  WidgetElement.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import Foundation

struct WidgetElement: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var isSmall: Bool = false
    var type: ElementType

    var book: WidgetBook?
    var books: [WidgetBook]?

    var stats: [String: String]?

    var list: WidgetList?
    var lists: [WidgetList]?
}

//
//  Widget.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

struct Widget: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var elements: [WidgetElement]
    var itemsMovable: Bool = false
}

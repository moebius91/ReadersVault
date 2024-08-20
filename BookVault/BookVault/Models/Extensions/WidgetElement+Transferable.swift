//
//  WidgetElement+Transferable.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

extension WidgetElement: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .widgetElement)
    }
}

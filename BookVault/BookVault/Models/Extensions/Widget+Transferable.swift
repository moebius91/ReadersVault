//
//  Widget+Transferable.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 16.08.24.
//

import SwiftUI

extension Widget: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .widget)
    }
}

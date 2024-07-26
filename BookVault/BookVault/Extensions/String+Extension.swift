//
//  String+Extension.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 05.07.24.
//

import Foundation

// Mit Hilfe von ChatGPT erstellt.

// Diese Funktion kürzt den String auf die übergebene Anzahl Zeichen
// und fügt am Ende … hinzu, wenn es zu viele Zeichen sind
extension String {
    func truncate(length: Int) -> String {
        if self.count > length {
            return String(self.prefix(length - 1)) + "…"
        } else {
            return self
        }
    }
}

// Überprüft ob der String eine Ganzzahl (Int) ist. Gibt einen Boolean aus.
extension String {
    var isNumeric: Bool {
        return Int(self) != nil
    }
}

extension String {
    var toInt: Int? {
        let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedString.isEmpty else {
            return nil
        }

        guard trimmedString.isNumeric else {
            return nil
        }

        return Int(trimmedString)
    }
}

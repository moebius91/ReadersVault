//
//  String+Extension.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 05.07.24.
//

import Foundation

// Mit Hilfe von ChatGPT erstellt. Diese Funktion kürzt den String auf die übergebene Anzahl Zeichen und fügt am Ende ... hinzu, wenn es zu viele Zeichen waren
extension String {
    func truncate(length: Int) -> String {
        if self.count > length {
            return String(self.prefix(length - 3)) + "..."
        } else {
            return self
        }
    }
}

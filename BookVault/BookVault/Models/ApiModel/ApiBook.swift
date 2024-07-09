//
//  ApiBook.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 03.07.24.
//

import Foundation

struct ApiBook: Codable, Hashable {
    let publisher: String?
    let image: URL
    let title_long: String?
    let authors: [String]?
    let title: String
    let isbn13: String
    let isbn: String
    let isbn10: String?
}

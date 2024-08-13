//
//  FireBook.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 13.08.24.
//

import Foundation

struct FireBook: Codable, Identifiable {
    let id: String
    let isbn: String
    let isbn10: String
    let isbn13: String
    let isFavorite: Bool
    let isDesired: Bool
    let isRead: Bool
    let isLoaned: Bool
    let isOwned: Bool
    let publisher: String
    let shortDescription: String
    let title: String
    let titleLong: String
    let coverImage: Data?
    let coverUrl: URL

//    let authors: [CDAuthor]
//    let lists: [CDList]
//    let notes: [CDNote]
//    let tags: [CDTag]
//    let categories: [CDCategory]
}

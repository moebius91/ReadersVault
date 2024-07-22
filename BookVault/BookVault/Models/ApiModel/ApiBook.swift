//
//  ApiBook.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 03.07.24.
//

import Foundation

struct ApiBook: Codable, Hashable {
    let publisher: String?
    let title: String
    let image: URL?
    let title_long: String?
    let authors: [String]?
    let isbn13: String
    let isbn: String
    let isbn10: String?
    let synopsis: String?
    
    var buyURL: URL? {
        URL(string:"https://www.amazon.de/s?k=\(isbn13)&linkCode=ll2&tag=moebius06-21&linkId=5ab80d3a57bd52a2034705ea1de83d6b&language=de_DE&ref_=as_li_ss_tl")
    }
}

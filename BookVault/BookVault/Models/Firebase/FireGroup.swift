//
//  FireGroup.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import Foundation
import FirebaseFirestore

struct FireGroup: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let creatorId: String

    let createdAt: Date
    var userlist: [FireUser] = []
    var lastPost: String = ""
    var lastPostTimestamp: Date?
}

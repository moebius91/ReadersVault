//
//  FireGroupPost.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import Foundation
import FirebaseFirestore

struct FireGroupPost: Codable, Identifiable {
    @DocumentID var id: String?
    let groupId: String
    let groupName: String
    let userId: String
    let username: String
    let content: String
    let timestamp: Date
}

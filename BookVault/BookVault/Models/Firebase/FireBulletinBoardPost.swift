//
//  FireBulletinBoardPost.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 08.08.24.
//

import Foundation
import FirebaseFirestore

struct FireBulletinBoardPost: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var content: String
    let userId: String
    let timestamp: Date
}

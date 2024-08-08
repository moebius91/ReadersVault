//
//  FireUser.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 07.08.24.
//

import Foundation

struct FireUser: Codable, Identifiable {
    let id: String
    let email: String
    let username: String
    let registeredAt: Date
}

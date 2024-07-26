//
//  ReadersVaultApp.swift
//  ReadersVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI
import Firebase

@main
struct ReadersVaultApp: App {

    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            NavigatorView()
        }
    }
}

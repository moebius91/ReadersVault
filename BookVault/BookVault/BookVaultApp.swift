//
//  BookVaultApp.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 01.07.24.
//

import SwiftUI
import Firebase

@main
struct BookVaultApp: App {
    
    init() {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
//            NavigatorView()
//            ScannerViewByMedium()
            ScannerView()
        }
    }
}

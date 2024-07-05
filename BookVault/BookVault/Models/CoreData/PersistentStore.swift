//
//  PersistentStore.swift
//  BookVault
//
//  Created by Jan-Nikolas Othersen on 03.07.24.
//

import Foundation
import CoreData

class PersistentStore {
    static let shared = PersistentStore()
    
    private let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        self.container = NSPersistentContainer(name: "BookVault")
        
        self.container.viewContext.automaticallyMergesChangesFromParent = true
        
        self.container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("Laden der Datenbank fehlgeschlagen: \(error.localizedDescription), UserInfo: \(error.userInfo)")
            }
        }
    }
    
    func save() {
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}

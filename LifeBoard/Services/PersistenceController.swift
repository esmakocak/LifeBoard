//
//  PersistenceController.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController() // Singleton
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model") // set CoreData Model as 'Model'
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreData yüklenemedi: \(error), \(error.userInfo)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}

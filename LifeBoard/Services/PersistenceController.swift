//
//  PersistenceController.swift
//  LifeBoard
//
//  Created by Esma Koçak on 10.02.2025.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController() // 📌 Singleton ile tek bir instance oluşturduk
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model") // 📌 CoreData Model'in adı "Model" olarak ayarlandı
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

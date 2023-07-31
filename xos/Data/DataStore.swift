//
//  FeedService.swift
//  macapp
//
//  Created by nick on 13/07/2023.
//

import CoreData
import Foundation

/// Controller to manage the app data
struct DataStore {
    /// Persistent container
    let container: NSPersistentContainer

    /// Exposes the managed object context
    var context: NSManagedObjectContext {
        container.viewContext
    }

    /// Static instance of the store
    static let shared: DataStore = .init()

    /// Preview instance of the store
    static var preview: DataStore = .init(inMemory: true)

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error {
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error)")
                }
            }
        }
    }

    /// Saves to persistent storage
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
                fatalError("DataStore save error \(error)")
            }
        }
    }
}

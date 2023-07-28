//
//  FeedService.swift
//  macapp
//
//  Created by nick on 13/07/2023.
//

import CoreData
import Foundation

/// Controller to manage the app data
struct DataController {
    /// Persistent container
    let container: NSPersistentContainer
    
    /// Static instance
    static let shared: DataController = DataController()
    
    /// Preview instance of the controller
    static var preview: DataController = DataController()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores {storeDescription, error in
            if let error = error {
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error)")
                }
            }
        }
    }
    
    /// Saves the context
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
                fatalError("Controller save error \(error)")
            }
        }
    }
}

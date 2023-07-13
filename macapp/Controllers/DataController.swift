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
    /// Static instance of that controller
    static let shared = DataController()
    
    /// Persistent container
    let container: NSPersistentContainer
    
    /// Preview instance of the controller
    static var preview: DataController = {
        let controller = DataController()
        let viewContext = controller.container.viewContext
        
        let feed = Feed(context: viewContext)
        feed.url = "https://news.ycombinator.com/rss"
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Data")
        
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

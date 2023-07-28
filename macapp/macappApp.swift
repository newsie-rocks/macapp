//
//  macappApp.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI

@main
struct macappApp: App {
    // NB: The state is alive as long as the App is alive
    /// data controller instance
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}

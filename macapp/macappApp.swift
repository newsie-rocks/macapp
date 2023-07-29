//
//  macappApp.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI

@main
struct macappApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    // NB: The state is alive as long as the App is alive
    /// data controller instance
    let dataStore = DataStore.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataStore.container.viewContext)
        }
        // NB: save when the app moves to the background
        .onChange(of: scenePhase) { _ in
            dataStore.save()
        }
#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}

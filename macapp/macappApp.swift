//
//  macappApp.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI

@main
struct macappApp: App {
    /// Scene phase
    @Environment(\.scenePhase) var scenePhase
    
    /// data controller instance
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }.onChange(of: scenePhase) {_ in
            // NB: save the data when the app is put in the background
            dataController.save()
        }
#if os(macOS)
        Settings {
            SettingsView()
        }
#endif
    }
}

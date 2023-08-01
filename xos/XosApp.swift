//
//  macappApp.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI

@main
struct XosApp: App {
    let feedsController: FeedsController = .shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(feedsController)
        }
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

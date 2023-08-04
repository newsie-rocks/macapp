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
    let searchController: SearchController = .shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(feedsController)
                .environmentObject(searchController)
        }
        #if os(macOS)
//        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}

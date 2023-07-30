//
//  macappApp.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI

@main
struct MacappApp: App {
    let feedsController: FeedsController = FeedsController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(feedsController)
        }
// #if os(macOS)
//        Settings {
//            SettingsView()
//        }
// #endif
    }
}

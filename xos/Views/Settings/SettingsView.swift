//
//  SettingsView.swift
//  macapp
//
//  Created by nick on 13/07/2023.
//

import SwiftUI

/// Settings view
struct SettingsView: View {
    @AppStorage("showPreview") private var showPreview = true
    @AppStorage("fontSize") private var fontSize = 12.0

    var body: some View {
        List {
            Section("Account") {
                HStack {
                    Label("Email", systemImage: "envelope")
                    Toggle("", isOn: $showPreview)
                }
                HStack {
                    Label("Name", systemImage: "person")
                    Slider(value: $fontSize, in: 9...96) {
                        Text("Font Size (\(fontSize, specifier: "%.0f") pts)")
                    }
                }

            }
            Section("App settings") {
                Label("API key", systemImage: "key")
            }
        }
        .navigationTitle("Settings")
    }
}

/// Settings preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//
//  Styles.swift
//  macapp
//
//  Created by nick on 13/07/2023.
//
// Shared styles

import SwiftUI

/// Outline style for Button
struct OutlineStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 44, minHeight: 44)
            .padding(.horizontal)
            .foregroundColor(Color.accentColor)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor))
    }
}

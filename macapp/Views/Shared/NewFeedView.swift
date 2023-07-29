//
//  NewFeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI

struct NewFeedView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var url: String = ""
    @State private var name: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("URL", text: $url).keyboardType(.URL).textContentType(.URL)
                TextField("Name", text: $name)
            } header: {
                Text("Add a new feed")
            }
            Button("Add this feed") {
                showError = !showError
            }
            Button("Cancel") {
                dismiss()
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("An error occured"),
                message: Text("error")
            )
        }
    }
}

struct NewFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewFeedView()
    }
}

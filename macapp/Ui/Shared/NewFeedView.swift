//
//  NewFeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI

struct NewFeedView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var feedUrl: String = ""
    @State private var feedName: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        Form {
            Section {
                TextField("URL", text: $feedUrl)
                TextField("Name", text: $feedName)
            } header: {
                Text("Add a new feed")
            }
            Section {
                Button("Add this feed") {
                    showError = !showError
                }
                Button("Cancel") {
//                    dismiss.callAsFunction()
                }
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

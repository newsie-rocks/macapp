//
//  NewFeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import CoreData
import SwiftUI

private enum FocusedField {
    case url, name
}

struct AddFeedView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var feedsController: FeedsController

    @State private var url: String = ""
    @State private var name: String = ""
    @State private var error: String?
    @State private var showError: Bool = false
    @State private var isInProgress: Bool = false

    @FocusState private var focusedField: FocusedField?

    private func submit() async {
        isInProgress = true
        defer { isInProgress = false }

        switch await feedsController.addFeed(
            url,
            name: name
        ) {
        case .success:
            error = nil
            showError = false
            dismiss()
        case .failure(let opError):
            error = opError.errorDescription
            showError = true
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("URL", text: $url)
                        .keyboardType(.URL)
                        .textContentType(.URL)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .url)
                        .disabled(isInProgress)
                    TextField("Name", text: $name)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .name)
                        .disabled(isInProgress)
                }
            }
            .navigationTitle("New feed")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled(isInProgress)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .disabled(isInProgress)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if !isInProgress {
                        Button {
                            Task {
                                await submit()
                                isInProgress = false
                            }
                        } label: {
                            Text("Add").bold()
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .onAppear {
                focusedField = .url
            }
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("Error"),
                    message: Text("\(error ?? "")")
                )
            }
        }
    }
}

struct NewFeedView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeedView()
            .environmentObject(FeedsController.preview)
    }
}

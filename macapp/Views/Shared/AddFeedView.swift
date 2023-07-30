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
    @EnvironmentObject var feedsController: FeedsController
    @Environment(\.dismiss) private var dismiss

    @State private var url: String = ""
    @State private var name: String = ""
    @FocusState private var focusedField: FocusedField?
    @State private var error: String? = nil
    @State private var showError: Bool = false
    @State private var isInProgress: Bool = false

    private func submit() async {
        isInProgress = true
        defer { isInProgress = false }

        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            try await feedsController.addFeed(
                url ?! AppError.generic("Invalid url"),
                name: name
            )
            dismiss()
        } catch AppError.generic(let message),
            AppError.invalidParam(let message)
        {
            self.error = message
            showError = true
        } catch {
            self.error = "An error occurred"
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
                        .focused($focusedField, equals: .url)
                    TextField("Name", text: $name)
                        .disableAutocorrection(true)
                        .focused($focusedField, equals: .name)
                }
            }
            .navigationTitle("New feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !isInProgress {
                        Button {
                            Task {
                                await submit()
                            }
                        } label: {
                            Text("Add").bold()
                        }
                    } else {
                        ProgressView()
                    }
                }
            }
            .disabled(isInProgress)
            .interactiveDismissDisabled(isInProgress)
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

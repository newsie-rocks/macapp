//
//  SearchView.swift
//  xos
//
//  Created by nick on 02/08/2023.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var searchController: SearchController
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false

    func runSearch() async {
        isSearching = true
        await searchController.search(query: searchText)
        isSearching = false
        dismiss()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter your search query ...", text: $searchText, axis: .vertical)
                        .lineLimit(3...)
                }
            }
            .onSubmit {
                Task {
                    await runSearch()
                }
            }
            .submitLabel(.search)
            .disabled(isSearching)
            .interactiveDismissDisabled(isSearching)
            .navigationTitle("Search")
            .toolbar {
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button {
                        Task {
                            await runSearch()
                        }
                    } label: {
                        if isSearching {
                            ProgressView()
                        } else {
                            Text("Search")
                        }
                    }
                }

                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

//
//  SearchController.swift
//  xos
//
//  Created by nick on 04/08/2023.
//

import CoreData
import FeedKit
import Foundation

class SearchController: ObservableObject {
    /// Data store
    private let store: DataStore

    /// Searches
    @Published var searches: [Search] = []

    init(_ store: DataStore) {
        self.store = store
        refreshCache()
    }

    /// Shared instance of the controller
    static let shared: SearchController = .init(DataStore.shared)

    /// Preview instance of the controller
    static let preview: SearchController = .init(DataStore.preview)

    /// Searches a feed
    func search(query: String) async {
        let search = Search(context: store.context)
        search.id = UUID()
        search.date = Date.now
        search.query = query

        // simulate API call and retrieve the articles for a search
        try? await Task.sleep(nanoseconds: 1_000_000_000)
//        search.addToArticles(<#T##value: Article##Article#>)

        store.save()
        refreshCache()
    }

    /// Deletes a search
    func deleteSearch(_ search: Search) {
        store.context.delete(search)
    }

    /// Refreshes the cache with al feeds
    private func refreshCache() {
        let request = NSFetchRequest<Search>(entityName: "Search")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]

        var results: [Search] = []
        do {
            results = try store.context.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        DispatchQueue.main.async {
            self.searches = results
        }
    }
}

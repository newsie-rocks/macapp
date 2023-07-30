//
//  FeedController.swift
//  macapp
//
//  Created by nick on 29/07/2023.
//

import Foundation
import CoreData
import FeedKit

/// Data controller
///
/// # Notes
///
/// See https://xavier7t.com/crud-with-core-data-in-swiftui
class FeedsController: ObservableObject {
    /// Data store
    private let store: DataStore

    /// Feeds
    @Published var feeds: [Feed] = []

    /// Built-in feeds
    @Published var builtInFeeds: [Feed] = []

    init(_ store: DataStore) {
        self.store = store
        refresh()
    }

    /// Shared instance of the DataController
    static let shared: FeedsController = FeedsController(DataStore.shared)

    /// Preview instance of the DataController
    static let preview: FeedsController = FeedsController(DataStore.preview)

    /// Refreshes  the feeds
    func refresh() {
        let request = NSFetchRequest<Feed>(entityName: "Feed")

        var results: [Feed] = []
        do {
            results = try store.context.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        feeds = results
    }

    /// Adds a new feed
    func addFeed(
        _ url: String,
        name: String?
    ) async throws {
        // validate the url
        let link = try URL(string: url) ?! AppError.invalidParam("Invalid URL \(url)")

        // read the feed
        let parser = FeedParser(URL: link)
//        let res = await parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
//            // Do your thing, then back to the Main thread
//            DispatchQueue.main.async {
//                // ..and update the UI
//            }
//        }

        let feed = Feed(context: store.context)
        feed.id = UUID()
        feed.link = link
        feed.name = name
//        feed.title = title

        store.save()
        refresh()
    }

    /// Deletes a feed
    func deleteFeed(_ feed: Feed) {
        store.context.delete(feed)
        store.save()
        refresh()
    }

    /// Exposes the built-in feeds
    func x_builtInFeeds() -> [Feed] {
        []
    }
}

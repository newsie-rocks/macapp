//
//  FeedController.swift
//  macapp
//
//  Created by nick on 29/07/2023.
//

import CoreData
import FeedKit
import Foundation

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
    static let shared: FeedsController = .init(DataStore.shared)

    /// Preview instance of the DataController
    static let preview: FeedsController = .init(DataStore.preview)

    /// Refreshes  the feeds
    func refresh() {
        let request = NSFetchRequest<Feed>(entityName: "Feed")

        var results: [Feed] = []
        do {
            results = try store.context.fetch(request)
        } catch {
            print("Could not fetch notes from Core Data.")
        }

        DispatchQueue.main.async {
            self.feeds = results
        }
    }

    /// Adds a new feed
    func addFeed(
        _ url: String,
        name: String?
    ) async -> Result<Void, AppError> {
        // check the URL is valid
        guard let link = URL(string: url) else {
            return .failure(.invalidParam("invalid URL \(url)"))
        }

        // parse the feed
        let rawFeed: FeedKit.Feed
        let parser = FeedKit.FeedParser(URL: link)
        switch await parser.asyncParse() {
        case .success(let feed):
            rawFeed = feed
        case .failure(let error):
            print(error)
            return .failure(AppError.invalidParam("invalid RSS feed"))
        }

        let feed = Feed(context: store.context)
        feed.id = UUID()
        switch rawFeed {
        case .rss(let rssFeed):
            feed.title = rssFeed.title
        case .atom(let atomFeed):
            feed.title = atomFeed.title
        case .json(let jsonFeed):
            feed.title = jsonFeed.title
        }

        store.save()
        refresh()
        return .success(())
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

// NB: extension to convert the FeedKit callback to an async method
extension FeedParser {
    /// Parses a feed asynchronously
    func asyncParse() async -> Result<FeedKit.Feed, ParserError> {
        await withCheckedContinuation { continuation in
            self.parseAsync(queue: DispatchQueue(label: "my.concurrent.queue", attributes: .concurrent)) { result in
                continuation.resume(returning: result)
            }
        }
    }
}

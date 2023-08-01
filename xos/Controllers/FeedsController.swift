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
        refreshCache()
    }

    /// Shared instance of the controller
    static let shared: FeedsController = .init(DataStore.shared)

    /// Preview instance of the controller
    static let preview: FeedsController = .init(DataStore.preview)

    // Loads sample data
    func loadSamples() async {
        // add sample data for preview
        var samples: [(String, String?)] = []
        samples.append(("https://spectrum.ieee.org/feeds/feed.rss", nil))
        samples.append(("https://simonwillison.net/atom/everything/", "Willison blog"))
        for sample in samples {
            if case .failure(let error) = await self.addFeed(sample.0, name: sample.1) {
                fatalError("Failed to load samples: \(error)")
            }
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

        // check that the feed is not already added
        if feeds.contains(where: { feed in
            feed.link == link
        }) {
            return .failure(.invalidParam("Already subscribed"))
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
        feed.link = link
        feed.extractFrom(rawFeed, extractArticles: true)

        store.save()
        refreshCache()
        return .success(())
    }

    /// Deletes a feed
    func deleteFeed(_ feed: Feed) {
        store.context.delete(feed)
        store.save()
        refreshCache()
    }

    /// Exposes the built-in feeds
    func x_builtInFeeds() -> [Feed] {
        []
    }

    /// Refreshes the cache with al feeds
    private func refreshCache() {
        let request = NSFetchRequest<Feed>(entityName: "Feed")
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]

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

extension Feed {
    /// Extracts the feed from the XML info
    func extractFrom(_ rawFeed: FeedKit.Feed, extractArticles: Bool = false) {
        switch rawFeed {
        case .rss(let rssFeed):
            title = rssFeed.title
            summary = rssFeed.description
            image = rssFeed.image?.url

        case .atom(let atomFeed):
            title = atomFeed.title
            image = atomFeed.logo

        case .json(let jsonFeed):
            title = jsonFeed.title
            summary = jsonFeed.description
            image = jsonFeed.icon
        }

        if extractArticles {
            switch rawFeed {
            case .rss(let rssFeed):
                extractRssFeedArticles(rssFeed)
            case .atom(let atomFeed):
                extractAtomFeedArticles(atomFeed)
            case .json(let jsonFeed):
                extractJsonFeedArticles(jsonFeed)
            }
        }
    }

    /// Checks if the feed contains an article
    func containsArticle(_ link: String?) -> Bool {
        let articles = self.articles?.allObjects as? [Article]
        return articles?.contains(where: {
            $0.link?.absoluteString == link
        }) ?? false
    }

    /// Extract the articles for a RSS feed
    private func extractRssFeedArticles(_ rssFeed: RSSFeed) {
        for item in rssFeed.items ?? [] {
            if containsArticle(item.link) {
                continue
            }

            let article: Article
            if let context = managedObjectContext {
                article = Article(context: context)
            } else {
                article = Article()
            }

            article.id = UUID()
            article.link = item.link.map { URL(string: $0) }!
            article.title = item.title
            article.date = item.pubDate
            if let content = item.content {
                article.summary = item.description
                article.content = content.contentEncoded
            } else {
                article.content = item.description
            }
            addToArticles(article)
        }
    }

    /// Extract the articles for an Atom feed
    private func extractAtomFeedArticles(_ atomFeed: AtomFeed) {
        for entry in atomFeed.entries ?? [] {
            let link = entry.links?.first?.attributes?.href
            if containsArticle(link) {
                continue
            }

            let article: Article
            if let context = managedObjectContext {
                article = Article(context: context)
            } else {
                article = Article()
            }

            article.id = UUID()
            article.link = link.map { URL(string: $0) }!
            article.title = entry.title
            article.date = entry.published
            article.summary = entry.summary?.value
            article.content = entry.content?.value

            addToArticles(article)
        }
    }

    /// Extract the articles for a JSON feed
    private func extractJsonFeedArticles(_ jsonFeed: JSONFeed) {
        for item in jsonFeed.items ?? [] {
            if containsArticle(item.url) {
                continue
            }

            let article: Article
            if let context = managedObjectContext {
                article = Article(context: context)
            } else {
                article = Article()
            }

            article.id = UUID()
            article.link = item.url.map { URL(string: $0) }!
            article.title = item.title
            article.date = item.datePublished
            article.summary = item.summary
            article.content = item.contentHtml
            addToArticles(article)
        }
    }
}

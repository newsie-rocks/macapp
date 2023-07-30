//
//  FeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var feed: Feed

    var articles: [Article] = []

    var body: some View {
        VStack {
            Text("\(feed.title ?? "")")
            Text("\(feed.link?.absoluteString ?? "")")
            List {
                ForEach(articles) { _ in
                    ArticleRow(title: "Article here")
                }
            }
        }
        .navigationTitle("_")
    }
}

/// A row for a single article
private struct ArticleRow: View {
    var title: String

    var body: some View {
        NavigationLink {
            // NB: This shows as a separate page
            ArticleView()
        } label: {
            Label("An article", systemImage: "folder")
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static let dataStore = DataStore.preview

    static private var feed: Feed = {
        var feed = Feed(context: dataStore.container.viewContext)
        feed.id = UUID()
        feed.link = URL(string: "https://ai.googleblog.com/atom.xml")
        feed.title = "My feed"
        return feed
    }()

    static var previews: some View {
        FeedView(feed: feed)
    }
}

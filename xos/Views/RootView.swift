//
//  ContentView.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import CoreData
import SwiftUI

struct RootView: View {
    @EnvironmentObject var feedsController: FeedsController
    @State private var colVisibility = NavigationSplitViewVisibility.all
    @State private var selectedFeed: Feed?
    @State private var selectedArticle: Article?

    var body: some View {
        NavigationSplitView(columnVisibility: $colVisibility) {
            FeedListView(selectedFeed: $selectedFeed)
        } content: {
            if let feed = selectedFeed {
                FeedView(feed: feed, selectedArticle: $selectedArticle)
            }
        } detail: {
            if let article = selectedArticle {
                ArticleView(article: article)
            }
        }
        .onAppear {
            colVisibility = .all
        }
    }
}

/// Preview
struct RootView_Previews: PreviewProvider {
    static let controller: FeedsController = .preview

    static var previews: some View {
        RootView()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(controller)
            .task {
                await controller.loadSamples()
            }
    }
}

//
//  ContentView.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import CoreData
import SwiftUI

/// Content type for the root view
enum RootViewContent: Hashable {
    case feed(Feed)
    case search(Search)
}

struct RootView: View {
    @EnvironmentObject private var feedsController: FeedsController
    @State private var activeContent: RootViewContent?
    @State private var activeArticle: Article?
    @State private var colVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView {
            SideBarView(activeContent: $activeContent)
        } content: {
            if let content = activeContent {
                switch content {
                case .feed(let feed):
                    FeedView(feed: feed, activeArticle: $activeArticle)
                case .search(let search):
                    SearchFeedView(search)
                }
            }
        } detail: {
            if let article = activeArticle {
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

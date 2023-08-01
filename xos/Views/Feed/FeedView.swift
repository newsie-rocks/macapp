//
//  FeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject var feedsController: FeedsController
    @ObservedObject var feed: Feed
    @Binding var selectedArticle: Article?
    @State private var isInfoMenuOpened: Bool = false

    var logoUrl: URL? {
        feed.image.flatMap { URL(string: $0) }
    }

    var articles: [Article] {
        feed.articles.array(of: Article.self)
            .sorted(by: { $0.date ?? Date.now > $1.date ?? Date.now })
    }

    var body: some View {
        VStack(alignment: .leading) {
            List(selection: $selectedArticle) {
                Section {
                    ForEach(articles) { article in
                        NavigationLink(value: article) {
                            ArticleRow(article: article)
                        }
                    }
                }
            }
            #if os(iOS)
            .listStyle(.grouped)
            #endif
            .refreshable {
                switch await feedsController.refreshFeed(feed) {
                case .success:
                    break
                case .failure:
                    // TODO: display an error
                    break
                }
            }
        }
        .navigationTitle("Feed")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                AsyncImage(url: logoUrl) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 24, height: 24)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    isInfoMenuOpened = true
                } label: {
                    Image(systemName: "info.circle")
                }
                .sheet(isPresented: $isInfoMenuOpened) {
                    FeedInfoView(feed: feed)
                        .presentationDetents([.medium])
                        .padding()
                }
            }
        }
    }
}

/// A row for a single article
private struct ArticleRow: View {
    @ObservedObject var article: Article

    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title ?? "")
            Spacer()
                .frame(height: 8)
            if let summary = article.summary {
                Text(summary)
                    .font(.caption)
                    .lineLimit(3)
                Spacer()
                    .frame(height: 8)
            }
            Text(article.date?.formatted() ?? "")
                .font(.caption)
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static let controller = FeedsController.preview

    // Container for a stateful PreviewProvider
    // cf. https://peterfriese.dev/posts/swiftui-previews-interactive/
    struct Container: View {
        @EnvironmentObject var controller: FeedsController
        @State var feed: Feed?
        @State var selectedArticle: Article?

        var body: some View {
            NavigationStack {
                if let feed = feed {
                    FeedView(feed: feed, selectedArticle: $selectedArticle)
                } else {
                    Text("feed not initialised")
                }
            }
            .task {
                await controller.loadSamples()
                feed = controller.feeds.first
            }
        }
    }

    static var previews: some View {
        Container()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(controller)
    }
}

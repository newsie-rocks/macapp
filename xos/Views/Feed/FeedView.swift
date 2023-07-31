//
//  FeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var feed: Feed
    @State var isInfoMenuOpened: Bool = false

    var logoUrl: URL? {
        feed.image.flatMap { URL(string: $0) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            List {
//                Section {
//                    Text(feed.title ?? "")
//                        .font(.title2)
//                        .bold()
//                }
                Section {
                    ForEach(feed.articles.array(of: Article.self)) { article in
                        ArticleRow(article: article)
                    }
                }
            }
            #if os(iOS)
            .listStyle(.grouped)
            #else
            .listStyle(.plain)
            #endif
            .navigationDestination(for: Article.self) { article in
                ArticleView(article: article)
            }
        }
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
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
        NavigationLink(value: article) {
            VStack(alignment: .leading) {
                Text(article.title ?? "")
                Spacer()
                    .frame(height: 8)
                // TODO: fix description
                Text("FIXME Description")
                    .font(.caption)
            }
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

        var body: some View {
            NavigationStack {
                if let feed = feed {
                    FeedView(feed: feed)
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

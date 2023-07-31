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

    var articles: [Article] = []

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(feed.title ?? "")
                    .font(.title2)
                    .bold()
                    .padding()
                Text("Description")
//                if let desc = feed.desc {
//                    Text(desc)
//                }
            }

            Spacer()
            List {
                ForEach(articles) { _ in
                    ArticleRow(title: "Article here")
                }
            }
        }
        .padding()
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
                    VStack {
                        Grid(alignment: .topLeading, horizontalSpacing: 8) {
                            GridRow {
                                Text("Title")
                                Text(feed.title ?? "")
                            }
                            GridRow {
                                Text("Link")
                                Text(feed.link?.absoluteString ?? "")
                            }
                            GridRow {
                                Text("Description")
                                Text(feed.desc ?? "")
                            }
                            GridRow {
                                Text("Image")
                                Text(feed.image ?? "")
                            }
                        }
                        .font(.system(size: 12))
                        Spacer()
                    }
                    .presentationDetents([.medium])
                    .padding()
                }
            }
        }
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

    private static var feed: Feed = {
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

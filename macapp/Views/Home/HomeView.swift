//
//  ContentView.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import CoreData
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var feedsController: FeedsController

    @State private var isNewFeedSheetOpened = false

    private func deleteFeeds(at offsets: IndexSet) {
        for idx in offsets {
            let feed = feedsController.feeds[idx]
            feedsController.deleteFeed(feed)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section("Built-in feeds") {
                    ForEach(feedsController.builtInFeeds, id: \.self) { feed in
                        FeedRow(feed: feed)
                    }
                }
                Section("My feeds") {
                    ForEach(feedsController.feeds) { feed in
                        FeedRow(feed: feed)
                    }
                    .onDelete(perform: deleteFeeds)
                }
            }
            .listStyle(GroupedListStyle())
            .refreshable {
                feedsController.refresh()
            }
            .navigationDestination(for: Feed.self) { feed in
                FeedView(feed: feed)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 36.0)
                        .cornerRadius(6)
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        isNewFeedSheetOpened = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $isNewFeedSheetOpened) {
                        AddFeedView()
                    }
                    EditButton()
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

/// A row for a specific feed
private struct FeedRow: View {
    let feed: Feed

    var body: some View {
        // NB: we pass a Hashable value instead of a View, so that the view
        // is not created each time the row is rendered
        NavigationLink(value: feed) {
            // NB: This shows as a separate page
            Label("\(feed.title ?? "__")", systemImage: "book")
        }
    }
}

/////  Add new feed button
// private struct AddNewFeedButton: View {
//    @State private var isOpened = false;
//
//    var body: some View {
//        NavigationLink(destination: AddFeedView()) {
//            FeedView()
//        }
//        .sheet(isPresented: $isOpened) {
//            Text("Viewed")
//        }
//    }
// }

/// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(FeedsController.preview)
    }
}

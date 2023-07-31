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
                    // TODO: remove the ability to swipe delete
                    // .deleteDisabled(!editMode?.isEditing)
                }
            }
            #if os(iOS)
            .listStyle(.grouped)
            #else
            .listStyle(.plain)
            #endif
            .refreshable {
                feedsController.refresh()
            }
            .navigationDestination(for: Feed.self) { feed in
                FeedView(feed: feed)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
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
                    // FIXME: frozen buttons after sheet dismissal
                    // It seems that nesting the NavigationStack creates an issue with the
                    // toolbar buttons being "frozen" after the sheet is dismissed.
                    // It seems to be the case because the sheet hides the sheet toolbar,
                    // so we limit the sheet size to cover half the screen
                    .sheet(isPresented: $isNewFeedSheetOpened) {
                        AddFeedView()
                            .presentationDetents([.fraction(0.75)])
                    }
                    #if os(iOS)
                    EditButton()
                    #endif
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
    }
}

/// A row for a specific feed
private struct FeedRow: View {
    let feed: Feed

    var logoUrl: URL? {
        feed.image.flatMap { URL(string: $0) }
    }

    var body: some View {
        NavigationLink(value: feed) {
            HStack {
                AsyncImage(url: logoUrl) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                Spacer()
                    .frame(width: 12)
                VStack(alignment: .leading) {
                    Text(feed.title ?? "")
                    Spacer()
                        .frame(height: 8)
                    Text(feed.title ?? "")
                        .font(.caption)
                }
            }
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

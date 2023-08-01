//
//  SwiftUIView.swift
//  xos
//
//  Created by nick on 31/07/2023.
//

import SwiftUI

struct FeedListView: View {
    @EnvironmentObject var feedsController: FeedsController
    @Binding var selectedFeed: Feed?
    @State private var isNewFeedSheetOpened = false

    private func deleteFeeds(at offsets: IndexSet) {
        for idx in offsets {
            let feed = feedsController.feeds[idx]
            feedsController.deleteFeed(feed)
        }
    }

    var body: some View {
        List(selection: $selectedFeed) {
            Section("Built-in feeds") {
                ForEach(feedsController.builtInFeeds, id: \.self) { feed in
                    NavigationLink(value: feed) {
                        FeedRow(feed: feed)
                    }
                }
            }
            Section("My feeds") {
                ForEach(feedsController.feeds) { feed in
                    NavigationLink(value: feed) {
                        FeedRow(feed: feed)
                    }
                }
                .onDelete(perform: deleteFeeds)
                // TODO: remove the ability to swipe delete
                // .deleteDisabled(!editMode?.isEditing)
            }
        }
        .task {
            switch await feedsController.refreshAllFeeds() {
            case .success:
                break
            case .failure:
                // TODO: show error
                break
            }
        }
        .refreshable {
            switch await feedsController.refreshAllFeeds() {
            case .success:
                break
            case .failure:
                // TODO: show error
                break
            }
        }
        #if os(iOS)
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationTitle("Home")
        .toolbar {
            ToolbarItemGroup(placement: .principal) {
                // NB: Hides the main title on screen
                Text("")
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
                    AddFeedView(
                        onAdded: { feed in
                            selectedFeed = feed
                        }
                    )
                    .presentationDetents([.fraction(0.75)])
                }
                #if os(iOS)
                EditButton()
                #endif
            }

            #if os(iOS)
            ToolbarItemGroup(placement: .navigation) {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 36.0)
                    .cornerRadius(6)
            }

            ToolbarItemGroup(placement: .secondaryAction) {
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
            #endif
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
                Text(feed.summary ?? "")
                    .font(.caption)
                    .lineLimit(3)
            }
        }
    }
}

struct FeedListView_Previews: PreviewProvider {
    static let controller: FeedsController = .preview

    static var previews: some View {
        FeedListView(selectedFeed: .constant(nil))
            .previewInterfaceOrientation(.portrait)
            .environmentObject(controller)
            .task {
                await controller.loadSamples()
            }
    }
}

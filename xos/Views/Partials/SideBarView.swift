//
//  SwiftUIView.swift
//  xos
//
//  Created by nick on 31/07/2023.
//

import SwiftUI

struct SideBarView: View {
    @Binding var activeContent: RootViewContent?
    @EnvironmentObject private var feedsController: FeedsController
    @EnvironmentObject private var searchController: SearchController
    @State private var isNewFeedSheetOpened = false
    @State private var isSearchSheetOpened = false

    private func deleteFeeds(at offsets: IndexSet) {
        for idx in offsets {
            let feed = feedsController.feeds[idx]
            feedsController.deleteFeed(feed)
        }
    }

    private func deleteSearches(at offsets: IndexSet) {
        for idx in offsets {
            let search = searchController.searches[idx]
            searchController.deleteSearch(search)
        }
    }

    var body: some View {
        VStack {
            List(selection: $activeContent) {
                Section("My searches") {
                    ForEach(searchController.searches, id: \.self) { search in
                        NavigationLink(value: RootViewContent.search(search)) {
                            SearchRow(search: search)
                        }
                    }
                    .onDelete(perform: deleteSearches)
                }

                Section("My feeds") {
                    ForEach(feedsController.feeds) { feed in
                        NavigationLink(value: RootViewContent.feed(feed)) {
                            FeedRow(feed: feed)
                        }
                    }
                    .onDelete(perform: deleteFeeds)
                    // TODO: remove the ability to swipe delete
                    // .deleteDisabled(!editMode?.isEditing)
                }
            }
//            #if os(iOS)
//            .listStyle(.grouped)
//            #endif
        }
        .navigationTitle("Home")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
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
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    // NB: Hides the main title on screen
                    Text("")
                }

                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        isSearchSheetOpened = true
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .sheet(isPresented: $isSearchSheetOpened) {
                        SearchView()
                            .presentationDetents([.fraction(0.75)])
                    }

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
                                activeContent = .feed(feed)
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

/// A row for a specific search
private struct SearchRow: View {
    let search: Search

    var body: some View {
        VStack(alignment: .leading) {
            Text(search.query ?? "").lineLimit(1 ... 2)
            Spacer()
                .frame(height: 8)
            Text(search.date?.formatted() ?? "")
                .font(.caption)
        }
    }
}

struct SideBarView_Previews: PreviewProvider {
    static let feedsController: FeedsController = .preview
    static let searchController: SearchController = .preview

    static var previews: some View {
        SideBarView(activeContent: .constant(nil))
            .previewInterfaceOrientation(.portrait)
            .environmentObject(feedsController)
            .environmentObject(searchController)
            .task {
                await feedsController.loadSamples()
            }
    }
}

//
//  ContentView.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var isNewFeedSheetOpened = false

    @FetchRequest(entity: Feed.entity(), sortDescriptors: [])
    private var myFeeds: FetchedResults<Feed>
    
    private var builtInFeeds: [Feed] {
        myFeeds.map { feed in
            feed
        }
    }
    
    private func deleteFeeds(at offsets: IndexSet) {
        for idx in offsets {
            let feed = myFeeds[idx]
            managedObjectContext.delete(feed)
        }
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Cannot save Core data")
        }
    }
    
    var body: some View { 
        NavigationStack {
            List {
                Section("Built-in feeds") {
                    ForEach(builtInFeeds, id: \.self) { feed in
                        FeedRow(feed: feed)
                    }
                }
                Section("My feeds") {
                    ForEach(myFeeds) { feed in
                        FeedRow(feed: feed)
                    }
                    .onDelete(perform: deleteFeeds)
                }
            }
            .listStyle(GroupedListStyle())
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
            .sheet(isPresented: $isNewFeedSheetOpened) {
                NewFeedView()
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
//private struct AddNewFeedButton: View {
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
//}

/// Preview
struct HomeView_Previews: PreviewProvider {
    static let dataStore = DataStore.preview
    
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataStore.container.viewContext)
    }
}

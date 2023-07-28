//
//  ContentView.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var showNewFeedSheet = false

//    // https://www.hackingwithswift.com/books/ios-swiftui/how-to-combine-core-data-and-swiftui
//    @FetchRequest(entity: Feed.entity(), sortDescriptors: [])
    var feeds: [Int] = [1,2,3]
    
    func deleteFeeds(at offsets: IndexSet) {
        // TODO: delete feeds
    }
    
    var body: some View { 
        NavigationStack {
            List {
                Section("Built-in feeds") {
                    ForEach(feeds, id: \.self) { feed in
                        FeedRow(title: "My feed")
                    }
                }
                Section("My feeds") {
                    ForEach(feeds, id: \.self) { feed in
                        FeedRow(title: "My feed")
                    }
                    .onDelete(perform: deleteFeeds)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("My feeds")
            .navigationDestination(for: [String].self) { item in
                FeedView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing:
                    HStack {
                        Button {
                            showNewFeedSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        EditButton()
                        Button {
                            showNewFeedSheet = true
                        } label: {
                            Image(systemName: "gear")
                        }
                        
                    }
            )
            .sheet(isPresented: $showNewFeedSheet) {
                NewFeedView()
            }
        }
    }
}

/// A row for a specific feed
private struct FeedRow: View {
    var title: String
    
    var body: some View {
        // NB: we pass a Hashable value instead of a View, so that the view
        // is not created each time the row is rendered
        NavigationLink(value: "my_article") {
            // NB: This shows as a separate page
            Label("Here", systemImage: "folder")
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
    static let dataController = DataController.preview
    
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}

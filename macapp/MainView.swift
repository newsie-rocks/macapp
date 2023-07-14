//
//  ContentView.swift
//  macapp
//
//  Created by nick on 12/07/2023.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var feeds: FetchedResults<Feed>
    
    @State private var feedId: String?
    
    /// Active article
    @State private var article: Article?
    
    var body: some View {
        NavigationSplitView {
            Text("Today")
            Text("Tomorrow")
            Divider()
            List(feeds, selection: $feedId) { feed in
                Text("Feed")
            }.toolbar {
                Text("X")
            }
        } content: {
            ContentView()
        } detail: {
            DetailView(article: $article)
        }
        .navigationTitle("")
        .toolbar {
            Text("+")
            Text("-")
        }
    }
}

///  Add new feed button
struct AddNewFeedButton: View {
    @State private var isOpened = false;
    
    var body: some View {
        NavigationLink(destination: AddFeedView()) {
            Text("++")
        }
        .sheet(isPresented: $isOpened) {
            Text("Viewed")
        }
    }
}

/// View to add a new
struct AddFeedView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var feedUrl: String = ""
    @State var feedName: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Add a new feed 2")) {
                TextField("URL:", text: $feedUrl)
                TextField("Name:", text: $feedName)
            }
        }.padding(12)
    }
}

///  Content view
struct ContentView: View {
    var body: some View {
        Text("Content")
    }
}

///  Detailview
struct DetailView: View {
    @Binding var article: Article?
    
    var body: some View {
        Text("Detail")
    }
}

/// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}

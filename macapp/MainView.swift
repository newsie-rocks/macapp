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
    
    /// Shows the modal to add a new feed
    @State private var show_new_feed_modal: Bool = false
    
    private var items:[String] = [];
    
    var body: some View {
        NavigationStack {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item)")
//                    } label: {
//                        Text(text: item)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem {
//                    Button(action: openSettings) {
//                        Label("Open Settings", systemImage: "gearshape.fill")
//                    }.help("Open Settings")
//                }
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addFeed) {
//                        Label("Add Feed", systemImage: "plus")
//                    }
//                    .help("Add a feed")
//                    .sheet(isPresented: self.$show_new_feed_modal) {
//                        AddFeedSheet()
//                    }
//                }
//            }
                Text("Select an item")
            }
    }
    
    /// Adds a new feed
    private func addFeed() {
        self.show_new_feed_modal = true
        //        withAnimation {
        //            let newItem = Item(context: viewContext)
        //            newItem.timestamp = Date()
        //
        //            do {
        //                try viewContext.save()
        //            } catch {
        //                // Replace this implementation with code to handle the error appropriately.
        //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //                let nsError = error as NSError
        //                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        //            }
        //        }
    }
    
    /// Opens the settings
    private func openSettings() {
        // todo
    }
    
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

/// Sheet to add a new feed
struct AddFeedSheet: View {
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

/// Returns the data formatter
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

/// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, DataController.preview.container.viewContext)
    }
}

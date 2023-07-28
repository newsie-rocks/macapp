//
//  FeedView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI

struct FeedView: View {
    var articles: [Article] = []
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            List {
                ForEach(articles) { article in
                    ArticleRow(title: "Article here")
                }
            }
        }
        .navigationTitle("Title")
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
    static var previews: some View {
        FeedView()
    }
}

//
//  SearchFeedView.swift
//  xos
//
//  Created by nick on 04/08/2023.
//

import SwiftUI

struct SearchFeedView: View {
    let search: Search

    init(_ search: Search) {
        self.search = search
    }

    var body: some View {
        VStack {
            Text(search.query ?? "")
            List {
                ForEach(search.articles.array(of: Article.self)) { article in
                    Text(article.id?.uuidString ?? "")
                }
            }
        }
    }
}

// TODO: add search feed preview
// struct SearchFeedView_Previews: PreviewProvider {
//    static let search: Search?
//
//    static var previews: some View {
//        SearchFeedView()
//            .task {
//
//            }
//    }
// }

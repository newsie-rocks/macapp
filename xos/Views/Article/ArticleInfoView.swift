//
//  ArticleInfoView.swift
//  xos
//
//  Created by nick on 31/07/2023.
//

import SwiftUI

struct ArticleInfoView: View {
    @ObservedObject var article: Article

    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title ?? "").font(.title3).bold()
            Spacer().frame(height: 12)
            Text(article.summary ?? "").font(.body)
            Spacer().frame(height: 12)
            Text(article.link?.absoluteString ?? "")
            Spacer()
        }.padding()
    }
}

struct ArticleInfoView_Previews: PreviewProvider {
    static let controller = FeedsController.preview

    // Container for a stateful PreviewProvider
    // cf. https://peterfriese.dev/posts/swiftui-previews-interactive/
    struct Container: View {
        @EnvironmentObject var controller: FeedsController
        @State var article: Article?

        var body: some View {
            NavigationStack {
                if let article = article {
                    ArticleInfoView(article: article)
                } else {
                    Text("Article not initialised")
                }
            }
            .task {
                await controller.loadSamples()
                let feed = controller.feeds.first
                article = feed?.articles.array(of: Article.self).first
            }
        }
    }

    static var previews: some View {
        Container()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(controller)
    }
}

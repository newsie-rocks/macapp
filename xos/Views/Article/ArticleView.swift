//
//  ArticleView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI
import WebKit

struct ArticleView: View {
    @Environment(\.openURL) var openURL
    var article: Article
    @State var isInfoMenuOpened: Bool = false
    @State var isWebViewOpened: Bool = false

    var body: some View {
        // NB: we add a new navigation stack to open
        // the webpage inside a web view as a new view in that stack
        NavigationStack {
            VStack(alignment: .leading) {
                Text(article.title ?? "")
                    .font(.title2)
                    .bold()
                    .onTapGesture {
                        if let url = article.link {
                            openURL(url)
                        }
                    }
                Spacer().frame(height: 16)
                Text(article.date?.formatted() ?? "")
                    .font(.subheadline)
                Spacer().frame(height: 16)
                HTMLView(article.content ?? "")
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        if let url = article.link {
                            openURL(url)
                        }
                    } label: {
                        Image(systemName: "arrowshape.turn.up.right.circle")
                    }

                    if let url = article.link {
                        #if os(iOS)
                        NavigationLink {
                            WebView(url: url)
                                .presentationDetents([.large])
                        } label: {
                            Image(systemName: "eye.circle")
                        }
                        #else
                        #endif
                    }

                    ShareLink(item: article.link?.absoluteString ?? "")

                    Button {
                        isInfoMenuOpened = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                    .sheet(isPresented: $isInfoMenuOpened) {
                        ArticleInfoView(article: article)
                            .presentationDetents([.medium])
                            .padding()
                    }
                }
            }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static let controller = FeedsController.preview

    // Container for a stateful PreviewProvider
    // cf. https://peterfriese.dev/posts/swiftui-previews-interactive/
    struct Container: View {
        @EnvironmentObject var controller: FeedsController
        @State var article: Article?

        var body: some View {
            NavigationStack {
                if let article = article {
                    ArticleView(article: article)
                } else {
                    Text("Article not initialised")
                }
            }
            .task {
                await controller.loadSamples()
                let feed = controller.feeds.first
                article = feed?.articles.array(of: Article.self)
                    .sorted(by: { $0.date ?? Date.now > $1.date ?? Date.now })
                    .first
            }
        }
    }

    static var previews: some View {
        Container()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(controller)
    }
}

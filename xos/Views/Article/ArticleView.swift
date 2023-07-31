//
//  ArticleView.swift
//  macapp
//
//  Created by nick on 28/07/2023.
//

import SwiftUI
import WebKit

struct ArticleView: View {
    @ObservedObject var article: Article
    @State var isInfoMenuOpened: Bool = false
    @State var isWebViewOpened: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(article.title ?? "")
                    .font(.title2)
                    .bold()
                    .onTapGesture {
                        if let url = article.link {
                            UIApplication.shared.open(url)
                        }
                    }
                Spacer().frame(height: 16)
                Text(article.date?.formatted() ?? "")
                Spacer().frame(height: 16)
                Text(article.desc ?? "")
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    if let url = article.link {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Image(systemName: "arrowshape.turn.up.right.circle")
                }

                if let url = article.link {
                    NavigationLink {
                        WebView(url: url)
                            .presentationDetents([.large])
                    } label: {
                        Image(systemName: "eye.circle")
                    }
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

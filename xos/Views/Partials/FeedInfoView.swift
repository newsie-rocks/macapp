//
//  FeedInfoView.swift
//  xos
//
//  Created by nick on 31/07/2023.
//

import SwiftUI

struct FeedInfoView: View {
    @ObservedObject var feed: Feed

    var body: some View {
        VStack(alignment: .leading) {
            Text(feed.title ?? "").font(.title).bold()
            Spacer().frame(height: 12)
            Text(feed.summary ?? "").font(.body)
            Spacer().frame(height: 12)
            Text(feed.link?.absoluteString ?? "")
            Spacer()
        }.padding()
    }
}

struct FeedInfoView_Previews: PreviewProvider {
    static let controller = FeedsController.preview

    struct Container: View {
        @EnvironmentObject var controller: FeedsController
        @State var feed: Feed?

        var body: some View {
            NavigationStack {
                if let feed = feed {
                    FeedInfoView(feed: feed)
                } else {
                    Text("feed not initialised")
                }
            }
            .task {
                await controller.loadSamples()
                feed = controller.feeds.first
            }
        }
    }

    static var previews: some View {
        Container()
            .previewInterfaceOrientation(.portrait)
            .environmentObject(controller)
    }
}

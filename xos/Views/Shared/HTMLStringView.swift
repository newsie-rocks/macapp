//
//  HtmlStringView.swift
//  xos
//
//  Created by nick on 01/08/2023.
//

import SwiftUI
import WebKit

#if os(iOS)
public typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
public typealias ViewRepresentable = NSViewRepresentable
#endif

struct HTMLStringView: ViewRepresentable {
    let htmlContent: String

    init(_ htmlContent: String) {
        self.htmlContent = htmlContent.appending(
            """
            <style>
                body {
                    font-family: -apple-system, "Helvetica Neue", "Lucida Grande";
                    font-size: 3vw;
                    line-height: 1.6em;
                    text-align: justify;
                }

                img {
                    max-width: 100% !important;
                }

                iframe {
                    max-width: 100% !important;
                }
            </style>
            """
        )
    }

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // TODO: add baseURL
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // TODO: add baseURL
        // TODO: Open links externally
        nsView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct HTMLStringView_Previews: PreviewProvider {
    // swiftlint:disable line_length
    static var htmlContent = """
    <div class=\"img-div-any-width\">\n  <img src=\"/images/gen-ai-hero-image.jpg\" />\n  <br />\n</div>\n\n<p>Here are eight observations I’ve shared recently on the Cohere blog and videos that go over them.:</p>\n\n<p>Article: <a href=\"https://txt.cohere.com/generative-ai-future-or-present/\">What’s the big deal with Generative AI? Is it the future or the present?</a></p>\n<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/AeW9r3lopp0\" style=\"\nwidth: 100%;\n\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen=\"\"></iframe>\n\n<p>Article: <a href=\"https://txt.cohere.com/ai-is-eating-the-world/\">AI is Eating The World</a></p>\n<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/oTqG2DbXl2Y\" tyle=\"\nwidth: 100%;\nmax-width: 560px;\" title=\"YouTube video player\" frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share\" allowfullscreen=\"\"></iframe>
    """
    // swiftlint:enable line_length

    static var previews: some View {
        HTMLStringView(htmlContent)
    }
}

//
//  WebView.swift
//  xos
//
//  Created by nick on 31/07/2023.
//

import SwiftUI
import WebKit

#if os(iOS)
/// A basic Web view
struct BasicWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    @Binding var error: Error?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // This space can be left blank
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: BasicWebView

        init(_ parent: BasicWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//            print("Webview started loading.")
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//            print("Webview finished loading.")
            parent.isLoading = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Webview failed with error: \(error.localizedDescription)")
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
//            print("loading error: \(error)")
            parent.isLoading = false
            parent.error = error
        }
    }
}
#endif

#if os(iOS)
/// A web view with a loading indicator and error
struct WebView: View {
    let url: URL?
    @State private var isLoading = true
    @State private var error: Error?

    var body: some View {
        ZStack {
            if let error = error {
                Text(error.localizedDescription)
                    .foregroundColor(.pink)
            } else if let url = url {
                BasicWebView(url: url,
                        isLoading: $isLoading,
                        error: $error)
                    .edgesIgnoringSafeArea(.all)
                if isLoading {
                    ProgressView()
                }
            } else {
                Text("Sorry, we could not load this url.")
            }
        }
    }
}
#endif

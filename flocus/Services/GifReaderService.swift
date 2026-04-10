//
//  GifReaderService.swift
//  flocus
//
//  Created by Muhammad Dzakki Abdullah on 10/04/26.
//

import SwiftUI
import UIKit
import WebKit

struct GifReaderService : UIViewRepresentable {
    let gifName : String
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear        
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.isScrollEnabled = false
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif"), let data = try? Data (contentsOf: url) {
            webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
            
        } else {
            print("ERROR: Could not load GIF")
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}

struct gifReader_Previews: PreviewProvider {
    static var previews: some View {
        GifReaderService(gifName: "CactusGif")
    }
}

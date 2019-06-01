//
//  WebViewController.swift
//  PDFGenerator
//
//  Created by Manish Bhande on 29/05/2019.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var url: URL? {
        didSet { reload() }
    }

    var webview: UIWebView?
    var webkit: WKWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            webkit = WKWebView()
            view.addSubview(webkit!)
        } else {
            webview = UIWebView()
            view.addSubview(webview!)
        }
        reload()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webkit?.frame = view.bounds
        webview?.frame = view.bounds
    }
    
    private func reload() {
        if url == nil { return }
        webview?.loadRequest(URLRequest(url: url!))
        webkit?.load(URLRequest(url: url!))
    }
    
}

//
//  WebVC.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/15/18.
//  Copyright © 2018 slon. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    var webView: WKWebView! = nil
    var screenTitle: String! = nil
    var urlToLoad: URL! = nil
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    static func instantiateVC(screenTitle: String, urlToLoad: URL) -> WebVC {
        let vc = WebVC()
        vc.screenTitle = screenTitle
        vc.urlToLoad = urlToLoad
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = screenTitle
        self.webView.load(URLRequest(url: self.urlToLoad))
        webView.allowsBackForwardNavigationGestures = true
        self.showHUD()
    }
}

extension WebVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideHUD()
    }
}


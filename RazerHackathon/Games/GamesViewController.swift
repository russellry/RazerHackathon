//
//  GamesViewController.swift
//  RazerHackathon
//
//  Created by Russell Ong on 16/5/20.
//  Copyright © 2020 trillion.unicorn. All rights reserved.
//

import UIKit
import WebKit

class GamesViewController: UIViewController, UIScrollViewDelegate {
    var webView: WKWebView!
    var gameURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: gameURL!)!
        webView.load(URLRequest(url: url))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        disableScrollView(self.webView)
        self.webView.scrollView.delegate = self
    }
    

    func disableScrollView(_ view: UIView) {
        (view as? UIScrollView)?.isScrollEnabled = false
        view.subviews.forEach { disableScrollView($0) }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
      scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}


extension GamesViewController: WKNavigationDelegate {
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
}

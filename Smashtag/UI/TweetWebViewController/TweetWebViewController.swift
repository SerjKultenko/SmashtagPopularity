//
//  TweetWebViewController.swift
//  Smashtag
//
//  Created by Sergei Kultenko on 17/10/2017.
//  Copyright © 2017 Kultenko Sergey. All rights reserved.
//

import UIKit
import WebKit

class TweetWebViewController: UIViewController, WKUIDelegate
{
    @IBOutlet weak var webBackButton: UIBarButtonItem!

    var webView: WKWebView!
    
    var url: URL? {
        didSet {
            reloadURL()
        }
    }
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        
        webView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "canGoForward", options: .new, context: nil)
        
        updateButtonsStatus()
        reloadURL()
    }
    
    func reloadURL() {
        guard webView != nil, url != nil else {
            return
        }
        
        webView.load(URLRequest(url: url!))
    }
    
    @IBAction func webBackButtonAction(_ sender: Any) {
        guard webView != nil else {
            return
        }
        webView.goBack()
    }
    
    fileprivate func updateButtonsStatus() {
        webBackButton.isEnabled = webView.canGoBack
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard object is WKWebView, keyPath != nil else {
            return
        }
        switch keyPath! {
        case "canGoBack":
            updateButtonsStatus()
        default: break
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "canGoBack")
        webView.removeObserver(self, forKeyPath: "canGoForward")
    }
}

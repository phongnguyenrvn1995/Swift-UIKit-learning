//
//  DetailViewController.swift
//  Project-16
//
//  Created by Phong Nguyễn Hoàng on 24/09/2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressBar: UIProgressView!
    var capital: Capital!
    var btnBack: UIBarButtonItem!
    var btnForward: UIBarButtonItem!
    var btnRefresh: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = capital.title
        webView.navigationDelegate = self
        if let url = capital.url {
            webView.load(URLRequest(url: url))
        }
        
        navigationController?.isToolbarHidden = false
        
        btnBack = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back))
        btnRefresh = UIBarButtonItem(image: UIImage(systemName: "goforward"), style: .plain, target: self, action: #selector(refresh))
        btnForward = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(forward))
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [btnBack, space, btnRefresh, space, btnForward]
//        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        btnBack.isEnabled = webView.canGoBack
        btnForward.isEnabled = webView.canGoForward
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "estimatedProgress") {
            if let val = object as? WKWebView {
                progressBar.progress = Float(val.estimatedProgress)
            }
        }
    }
    
    @objc func back() {
        if(webView.canGoBack) {
            webView.goBack()
        }
    }
    
    @objc func forward() {
        if(webView.canGoForward) {
            webView.goForward()
        }
    }
    
    @objc func refresh() {
        webView.reload()
    }
}

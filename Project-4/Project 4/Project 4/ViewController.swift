//
//  ViewController.swift
//  Project 4
//
//  Created by Phong Nguyễn Hoàng on 26/04/2023.
//

import UIKit
import WebKit

class ViewController:  UIViewController, WKNavigationDelegate {

    public var initIndex = 0;
    var webView: WKWebView! = nil
    var progressView: UIProgressView! = nil
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initBar()
        firstLoadWebView()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func firstLoadWebView() {
        let url = URL(string: "https://\(InitTableViewController.websites[initIndex])")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func initBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(onRightBarButtonTap))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let bar = UIBarButtonItem(customView: progressView)
        
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: webView, action: #selector(webView.goBack))
        
        let forward = UIBarButtonItem(image: UIImage(systemName: "chevron.forward"), style: .done, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [bar, spacer, back, refresh, forward]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func onRightBarButtonTap() {
        let ac = UIAlertController(title: "Open Page", message: nil, preferredStyle: .actionSheet)
        for item in InitTableViewController.websites {
            ac.addAction(UIAlertAction(title: item, style: .default, handler: openPage(_:)))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(_ sender: UIAlertAction) {
        guard let senderTitle = sender.title else { return }
        guard let url = URL(string: "https://" + senderTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "estimatedProgress") {
            if let val = object as? WKWebView {
                progressView.progress = Float(val.estimatedProgress)
            }
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if(navigationAction.navigationType == .other) { // the case of nothing, not load action
            print("allow")
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        
        let url = navigationAction.request.url
        if let host = url?.host {
            print(host)
            for item in InitTableViewController.websites {
                if host.contains(item) {
                    print("allow")
                    decisionHandler(WKNavigationActionPolicy.allow)
                    return
                }
            }
        }
        print("not allow")
        decisionHandler(WKNavigationActionPolicy.cancel)
        showWebsiteBlocked()
    }
    
    private func showWebsiteBlocked() {
        let ac = UIAlertController(title: "FBI Warning", message: "This website is out of place!!!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive))
        present(ac, animated: true)
    }
}


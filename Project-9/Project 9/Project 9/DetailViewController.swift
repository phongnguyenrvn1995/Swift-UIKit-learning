//
//  DetailViewController.swift
//  Project 7
//
//  Created by Phong Nguyễn Hoàng on 14/06/2023.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView?
    var petition: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let petition = petition else { return }
        let html = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <style>
                body {
                    font-size: 150%;
                    color: red;
                }
            </style>
        </head>
        <body>
            \(petition.body)
        </body>
        </html>
        """
        webView?.loadHTMLString(html, baseURL: nil)
    }
    
    
}

//
//  AboutServiceViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/10/24.
//

import UIKit

import WebKit

final class AboutServiceViewController: UIViewController {
    
    private var webView: WKWebView?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 나중에 URL 변경
        let sURL = "https://useworld.github.io/iOS/webview/"
        let uURL = URL(string: sURL)
        let request = URLRequest(url: uURL!)
        guard let web = webView else { return }
        web.load(request)
    }
}

//
//  WebViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/11/24.
//

import UIKit

import WebKit

final class WebViewController: UIViewController {
    
    private var webView: WKWebView?
    
    private var urlString: String
    
    // URL String을 매개변수로 받는 initializer
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        webView = WKWebView(frame: self.view.frame)
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
    }
    
    private func setWebView() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView?.load(request)
        } else {
            print("Invalid URL string.")
        }
    }
}

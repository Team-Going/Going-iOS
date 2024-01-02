//
//  PersonalInfoWebViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit
import WebKit

final class PersonalInfoWebViewController: UIViewController {

    private var webView: WKWebView?

    override func loadView() {
           super.loadView()
           webView = WKWebView(frame: self.view.frame)
           self.view = self.webView
       }

       override func viewDidLoad() {
           super.viewDidLoad()
           
           //여기에 나중에 개인정보처리방침 사이트 넣으면 됨, 지금은 테스트로 아무거나 넣음
           let sURL = "https://useworld.github.io/iOS/webview/"
           let uURL = URL(string: sURL)
           let request = URLRequest(url: uURL!)
           guard let web = webView else { return }
           web.load(request)
       }
    

}

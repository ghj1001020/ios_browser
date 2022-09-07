//
//  ErrorDialogController.swift
//  Browser
//
//  Created by 권혁준 on 2020/10/10.
//  Copyright © 2020 권혁준. All rights reserved.
//

import UIKit
import WebKit

class ErrorDialogController: UIViewController , WKUIDelegate , WKNavigationDelegate {
    
    let TAG : String = "ErrorDialog"
    
    var errorMsg = "?errorMsg="

    @IBOutlet var wv_error: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        wv_error.uiDelegate = self
        wv_error.navigationDelegate = self
        
        wv_error?.autoresizingMask = [.flexibleWidth, .flexibleHeight]   // 뷰의 크기가 변경되면 서브뷰의 크기를 자동으로 조정
        wv_error?.backgroundColor = BRColor.colorByHex(hex: 0xeaeaea)    // 웹뷰 여백또는 배경을 흰색으로
        wv_error?.isOpaque = true    // 웹뷰 배경 불투명하게
        
        let htmlUrl = Bundle.main.url(forResource: "ErrorPage", withExtension: "html", subdirectory: "www")

        if let url = URL(string: errorMsg, relativeTo: htmlUrl) {
            let urlRequest = URLRequest(url: url)
            wv_error?.load( urlRequest )
        }
    }
    
    @IBAction func onClose(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Log.p("didCommit")
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Log.p("didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        Log.p("didReceiveServerRedirectForProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log.p("didFinish")
    }
}

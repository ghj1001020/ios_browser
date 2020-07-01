//
//  JsBridge.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/24.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import WebKit

class JsBridge : NSObject , WKScriptMessageHandler {
    
    
    // Js -> Native 간의 통신 설정
    func initJsBridge() -> WKWebViewConfiguration {
        let userContentController = WKUserContentController()
        // 브릿지 함수 정의
        userContentController.add(self, name: "test")
        let config = WKWebViewConfiguration()
        
        config.userContentController = userContentController
        return config
    }
    
    // Js -> Native 호출
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

    }
    
    // Native -> Js 호출
    func callJsFunction( webView : WKWebView , funcName : String , _ params : String...) {
        var js = funcName + "("
        var parameter = ""
        
        for (idx , param) in params.enumerated() {
            parameter = parameter + param
            if( idx < params.count - 1 ) {
                parameter = parameter + ","
            }
        }
        
        js = js + parameter + ")"
        
        webView.evaluateJavaScript(js, completionHandler: { (result, error) in
            
        })
    }
}

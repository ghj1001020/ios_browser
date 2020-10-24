//
//  JsBridge.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/24.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import WebKit

// 네이티브 호출 프로토콜
protocol JsBridgeProtocol {
    func jsBridgeCallback( requestId : Int , params : String )
}

class JsBridge : NSObject , WKScriptMessageHandler {
    
    private let TAG : String = "JsBridge"
    
    public var listener : JsBridgeProtocol? = nil
    

    // Js -> Native 간의 통신 설정
    func initJsBridge( listener : JsBridgeProtocol ) -> WKWebViewConfiguration {
        let userContentController = WKUserContentController()
        // 브릿지 함수 정의
        userContentController.add(self, name: "appAlertPopup")
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        config.allowsInlineMediaPlayback = true // HTML5 비디오가 인라인으로 재생되는지 전체화면으로 재생되는지
        config.mediaTypesRequiringUserActionForPlayback = .all  // 모든 미디어 유형에서 재생을 시작하려면 사용자 제스처 필요
        
        self.listener = listener
        return config
    }
    
    // Js -> Native 호출
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        Log.p(_tag: TAG, _message: "\(message.name) : \(message.body)")
        
        if !(message.body is String) {
            return
        }
        
        // 네이티브
        if( message.name == "appAlertPopup" ) {
            listener?.jsBridgeCallback( requestId: DefineCode.JS_ALERT_POPUP , params: message.body as! String )
        }
    }
    
    // Native -> Js 호출
    func callJsFunction( webView : WKWebView , funcName : String , _ params : [String], callback : ((Any?,Error?)->Void)? ) {
        var js = funcName + "("
        var parameter = ""
        
        for (idx , param) in params.enumerated() {
            parameter = parameter + "'" + param + "'"

            if( idx < params.count - 1 ) {
                parameter = parameter + ","
            }
        }
        
        js = js + parameter + ")"
        Log.p(_tag: TAG, _message: "js=" + js)

        webView.evaluateJavaScript(js, completionHandler: callback)
    }
    
    func callJsFunction( webView : WKWebView , funcName : String , _ params : [String] ) {
        callJsFunction(webView: webView, funcName: funcName, params, callback: nil)
    }
}

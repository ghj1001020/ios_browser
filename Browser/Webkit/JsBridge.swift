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
        userContentController.add(self, name: "appConsoleLog")  // 자바스크립트의 로그를 앱에서 처리
        
        // 웹뷰 확대/축소 지원
        let zoom = "document.getElementsByName(\"viewport\")[0].setAttribute(\"content\", \"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=5.0, user-scalable=yes\");"
        let zoomScript = WKUserScript(source: zoom, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(zoomScript)

        // console.log 오버라이드
        let consoleLog = "console.log = (function(orgConsole) { return function(msg) { window.webkit.messageHandlers.appConsoleLog.postMessage(msg); orgConsole.call(console, msg); } })(console.log);"
        let consoleLogScript = WKUserScript(source: consoleLog, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        userContentController.addUserScript(consoleLogScript)
        
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
        // start 웹킷로그
        let _date : String = Util.dateToString(date: Date(), format: "yyyyMMddHHmmss")
        let _function : String = "userContentController"
        let _param : String = "message.body : \(String(describing: message.body))"
        let _description : String = "웹 페이지에서 스크립트 메시지를 보냈다는 것을 핸들러에 알립니다."
        SQLiteService.insertWebkitLogData(params: [_date, _function, _param, _description])
        // end 웹킷로그

        if !(message.body is String) {
            return
        }
        
        // 네이티브
        if( message.name == "appAlertPopup" ) {
            listener?.jsBridgeCallback(requestId: DefineCode.JS_ALERT_POPUP, params: message.body as! String)
        }
        else if( message.name == "appConsoleLog" ) {
            listener?.jsBridgeCallback(requestId: DefineCode.JS_CONSOLE_LOG, params: message.body as! String)
        }
    }
    
    // Native -> Js 호출
    func callJsFunction( webView : WKWebView , funcName : String , _ params : [String], callback : ((Any?,Error?)->Void)? ) {
        // start 웹킷로그
        let _date : String = Util.dateToString(date: Date(), format: "yyyyMMddHHmmss")
        let _function : String = "웹 스크립트 함수 호출"
        let _param : String = "\(funcName)\n\(params.joined(separator: ","))"
        let _description : String = "앱에서 웹 스크립트 함수를 호출합니다."
        SQLiteService.insertWebkitLogData(params: [_date, _function, _param, _description])
        // end 웹킷로그
        
        var js = funcName + "("
        var parameter = ""
        
        for (idx , param) in params.enumerated() {
            parameter = parameter + "'" + param + "'"

            if( idx < params.count - 1 ) {
                parameter = parameter + ","
            }
        }
        
        js = js + parameter + ")"
        Log.p("js=" + js)

        webView.evaluateJavaScript(js, completionHandler: callback)
    }
    
    func callJsFunction( webView : WKWebView , funcName : String , _ params : [String] ) {
        callJsFunction(webView: webView, funcName: funcName, params, callback: nil)
    }
    
    // 자바스크립트 실행
    func evaluateJavascript( controller: UIViewController, webView: WKWebView, script: String, callback: ((Any?)->Void)? ) {
        
        webView.evaluateJavaScript(script) { (result: Any?, error: Error?) in
            if error != nil {
                let msg = error?.localizedDescription ?? ""
                // 실패
                _ = Util.showAlertDialog(controller: controller, title: "", message: "[error] \(msg)", action1: nil, action2: nil)
            }
            
            if let callback = callback {
                callback(result)
            }
        }
    }
}

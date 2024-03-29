//
//  DefineCode.swift
//  Browser
//
//  Created by 권혁준 on 2020/07/05.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

class DefineCode {
    
    public static let DEFAULT_PAGE = "https://www.naver.com"

    // 메뉴
    public static let MENU : [[String:String]] = [
        [
            "img" : "ic_toolbar_history" ,
            "name": "방문한페이지" ,
            "code": DefineCode.MORE_MENU_HISTORY
        ] ,
        [
            "img" : "ic_toolbar_webkit_log" ,
            "name": "웹킷로그" ,
            "code": DefineCode.MORE_MENU_WEBKIT_LOG
        ] ,
        [
            "img" : "ic_toolbar_log" ,
            "name": "콘솔로그" ,
            "code": DefineCode.MORE_MENU_CONSOLE_LOG
        ] ,
        [
            "img" : "ic_toolbar_cookie" ,
            "name": "쿠키" ,
            "code": DefineCode.MORE_MENU_COOKIE
        ] ,
        [
            "img" : "ic_toolbar_storage" ,
            "name": "Storage" ,
            "code": DefineCode.MORE_MENU_STORAGE
        ] ,
        [
            "img" : "ic_toolbar_exe" ,
            "name": "스크립트 실행" ,
            "code": DefineCode.MORE_MENU_EXE
        ] ,
        [
            "img" : "ic_toolbar_source" ,
            "name": "HTML 소스" ,
            "code": DefineCode.MORE_MENU_HTML_ELEMENT
        ] ,
        [
            "img" : "ic_toolbar_printer" ,
            "name": "프린터" ,
            "code": DefineCode.MORE_MENU_PRINT
        ] ,
        [
            "img" : "ic_toolbar_setting" ,
            "name": "설정" ,
            "code": DefineCode.MORE_MENU_SETTING
        ]
    ]
    
    
    // 다운로드 유형
    public static let URL_DOWNLOAD_NONE = 0
    public static let URL_DOWNLOAD_IMG = 1;
    public static let URL_DOWNLOAD_FILE = 2;
    
    
    // 더보기 메뉴코드
    public static let MORE_MENU_COOKIE = "00"
    public static let MORE_MENU_PRINT = "01"
    public static let MORE_MENU_STORAGE = "02"
    public static let MORE_MENU_HISTORY = "03"
    public static let MORE_MENU_CONSOLE_LOG = "04"
    public static let MORE_MENU_WEBKIT_LOG = "05"
    public static let MORE_MENU_EXE = "06"
    public static let MORE_MENU_HTML_ELEMENT = "07"
    public static let MORE_MENU_SETTING = "08"
    
    
    // JS 브릿지 코드
    public static let JS_ALERT_POPUP = 0
    public static let JS_CONSOLE_LOG = 1

}

// WEBKIT LOG TYPE코드
enum WebkitLogType : Int {
    case JS_TO_NATIVE = 0
    case NATIVE_TO_JS = 1
    case NATIVE_TO_JS_RETURN = 2
    case WEBVIEW_START = 3
    case WEBVIEW_REDIRECT = 4
    case WEBVIEW_FINISH = 5
    case WEBVIEW_ERROR = 6
    case WEBVIEW_SSL = 7
    case WEBVIEW_DECIDE_ACTION1 = 8
    case WEBVIEW_DECIDE_ACTION2 = 9
}

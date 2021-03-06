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

    
    // 다운로드 유형
    public static let URL_DOWNLOAD_NONE = 0
    public static let URL_DOWNLOAD_IMG = 1;
    public static let URL_DOWNLOAD_FILE = 2;
    
    // 더보기 메뉴코드
    public static let MORE_MENU_COOKIE = 0
    public static let MORE_MENU_PRINT = 1
    public static let MORE_MENU_PC_MOBILE_MODE = 2
    public static let MORE_MENU_HISTORY = 3
    public static let MORE_MENU_CONSOLE_LOG = 4
    public static let MORE_MENU_WEBKIT_LOG = 5
    public static let MORE_MENU_EXE = 6
    public static let MORE_MENU_HTML_ELEMENT = 7
    
    // JS 브릿지 코드
    public static let JS_ALERT_POPUP = 0
    public static let JS_CONSOLE_LOG = 1
}

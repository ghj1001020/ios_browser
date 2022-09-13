//
//  SQLiteService.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/16.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteService {

    // 테이블 생성
    public static func createTable() -> Bool {
        SQLite.shared.open()
        // 히스토리 테이블
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_HISTORY_TABLE)
        let tbl1 = SQLite.shared.execSQL(sql: DefineQuery.CREATE_HISTORY_TABLE)
        // 웹킷로그 테이블
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_WEBKIT_LOG_TABLE)
        let tbl2 = SQLite.shared.execSQL(sql: DefineQuery.CREATE_WEBKIT_LOG_TABLE)
        // 즐겨찾기 테이블
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_BOOKMARK_TABLE)
        let tbl3 = SQLite.shared.execSQL(sql: DefineQuery.CREATE_BOOKMARK_TABLE)
        
        SQLite.shared.close()
        
        return tbl1 && tbl2 && tbl3
    }
    
    // HISTORY_TBL에 데이터 입력
    public static func insertHistoryData(param: [Any]) -> [WebSiteData] {
        var urlList : [WebSiteData] = []
        
        SQLite.shared.open()
        
        SQLite.shared.execSQL(sql: DefineQuery.INSERT_HISTORY_URL, params: param)
        SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_URL) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let title : String = String(cString: sqlite3_column_text(stmt, 0))
                let url : String = String(cString: sqlite3_column_text(stmt, 1))
                
                let site = WebSiteData(date: "", title: title, url: url)
                urlList.append(site)
            }
        }
        
        SQLite.shared.close()
        
        return urlList
    }
    
    // HISTORY_TBL의 날짜그룹, 오늘날짜 히스토리 목록 조회
    public static func selectHistoryDatesAndUrls() -> [HistoryData] {
        var historyList : [HistoryData] = []
        
        SQLite.shared.open()
        
        // 날짜그룹
        SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_DATE_GROUP) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let date : String = String(cString: sqlite3_column_text(stmt, 0))
                historyList.append( HistoryData(date: date) )
            }
        }
        
        // 날짜별 URL목록
        if( historyList.count > 0 ) {
            for item in historyList {
                let params = [item.date]
                SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_URL_BY_DATE, params: params) { (stmt: OpaquePointer?) in
                    
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        let date : String = String(cString: sqlite3_column_text(stmt, 0))
                        let title : String = String(cString: sqlite3_column_text(stmt, 1))
                        let url : String = String(cString: sqlite3_column_text(stmt, 2))

                        let site = WebSiteData(date: date, title: title, url: url)
                        item.dataList.append(site)
                    }
                }
            }
            historyList[0].isOpen = true
        }
        
        SQLite.shared.close()
        
        return historyList
    }
    
    // HISTORY_TBL의 모든 데이터 삭제
    public static func deleteHistoryDataAll() {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.DELETE_HISTORY_DATA_ALL)
        SQLite.shared.close()
    }
    
    // HISTORY_TBL의 데이터 삭제
    public static func deleteHistoryData(date: String) -> Bool {
        var result = false

        SQLite.shared.open()
        result = SQLite.shared.execSQL(sql: DefineQuery.DELETE_HISTORY_DATA, params: [date])
        SQLite.shared.close()

        return result
    }
    
    // HISTORY_TBL의 검색 목록
    public static func selectHistorySearch(search: String) -> [HistoryData] {
        var historyList : [HistoryData] = []
        
        SQLite.shared.open()
        
        // 날짜그룹
        SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_SEARCH_GROUP, params: [search, search]) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let date : String = String(cString: sqlite3_column_text(stmt, 0))
                historyList.append( HistoryData(date: date, isOpen: true) )
            }
        }

        // 날짜별 URL목록
        if( historyList.count > 0 ) {
            for item in historyList {
                let params = [search, search, item.date]
                SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_SEARCH, params: params) { (stmt: OpaquePointer?) in
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        let date : String = String(cString: sqlite3_column_text(stmt, 0))
                        let title : String = String(cString: sqlite3_column_text(stmt, 1))
                        let url : String = String(cString: sqlite3_column_text(stmt, 2))
                        
                        let site = WebSiteData(date: date, title: title, url: url)
                        item.dataList.append(site)
                    }
                }
            }
        }

        SQLite.shared.close()
        
        return historyList
    }
    
    // HISTORY_TBL의 검색
    public static func selectHistorySearchUrl(search: String) -> [WebSiteData] {
        var siteList : [WebSiteData] = []
        
        SQLite.shared.open()

        let params = [search]
        SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_SEARCH, params: params) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let date : String = String(cString: sqlite3_column_text(stmt, 0))
                let title : String = String(cString: sqlite3_column_text(stmt, 1))
                let url : String = String(cString: sqlite3_column_text(stmt, 2))
                
                let site = WebSiteData(date: date, title: title, url: url)
                siteList.append(site)
            }
        }

        SQLite.shared.close()
        
        return siteList
    }
    
    // HISTORY_TBL의 URL그룹 목록
    public static func selectHistoryUrl() -> [WebSiteData] {
        var urlList : [WebSiteData] = []
        
        SQLite.shared.open()
        
        SQLite.shared.select(sql: DefineQuery.SELECT_HISTORY_URL) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let title : String = String(cString: sqlite3_column_text(stmt, 0))
                let url : String = String(cString: sqlite3_column_text(stmt, 1))
                
                let site = WebSiteData(date: "", title: title, url: url.lowercased())
                urlList.append(site)
            }
        }
        
        SQLite.shared.close()
        
        return urlList
    }
    
    
    // 웹킷로그 테이블에 데이터 입력
    public static func insertWebkitLogData(_ code: WebkitLogType, _ params: String, _ time: String = Util.dateToString(date: Date(), format: "yyyyMMddHHmmss")) {
        
        var data : [Any] = []
        data.append(MainViewController.WEBVIEW_LOAD_TIME)
        data.append(MainViewController.WEBVIEW_LOAD_URL)
        data.append(time)
        
        switch code {
        case .JS_TO_NATIVE:
            data.append("userContentController")
            data.append(params)
            data.append("웹 페이지에서 스크립트 메시지를 보냈다는 것을 핸들러에 알립니다.")
            break
        case .NATIVE_TO_JS:
            data.append("웹 스크립트 함수 호출")
            data.append(params)
            data.append("앱에서 웹 스크립트 함수를 호출합니다.")
            break
        case .NATIVE_TO_JS_RETURN:
            data.append("callJsFunction callback")
            data.append(params)
            data.append("웹 스크립트에서 반환한 값입니다.")
            break
        case .WEBVIEW_START:
            data.append("webView(_:didStartProvisionalNavigation:)")
            data.append(params)
            data.append("웹뷰에서 탐색이 시작되었음을 알립니다.")
            break
        case .WEBVIEW_REDIRECT:
            data.append("webView(_:didReceiveServerRedirectForProvisionalNavigation:)")
            data.append(params)
            data.append("웹뷰가 서버 리다이렉션을 수신했음을 알립니다.")
            break
        case .WEBVIEW_FINISH:
            data.append("webView(_:didFinish:)")
            data.append(params)
            data.append("탐색이 완료되었음을 알립니다.")
            break
        case .WEBVIEW_ERROR:
            data.append("webView(_:didFailProvisionalNavigation:withError:)")
            data.append(params)
            data.append("탐색 중에 오류가 발생했음을 알립니다.")
            break
        case .WEBVIEW_SSL:
            data.append("webView(_:didReceive:completionHandler:)")
            data.append(params)
            data.append("SSL인증에 응답하도록 요청합니다.")
            break
        case .WEBVIEW_DECIDE_ACTION1:
            data.append("webView(_:decidePolicyFor:decisionHandler:)")
            data.append(params)
            data.append("지정된 액션 정보를 기반으로 새로운 콘텐츠로 허가를 요청합니다.")
            break
        case .WEBVIEW_DECIDE_ACTION2:
            data.append("webView(_:decidePolicyFor:preferences:decisionHandler:)")
            data.append(params)
            data.append("지정된 액션 정보를 기반으로 새로운 콘텐츠로 허가를 요청합니다.")
            break
        }
        
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.INSERT_WEBKIT_LOG, params: data)
        SQLite.shared.close()
    }
    
    // 웹킷로그 목록 조회
    public static func selectWebkitLogData() -> [WebkitLogData] {
        var webkitLogList : [WebkitLogData] = []
        SQLite.shared.open()
        SQLite.shared.select(sql: DefineQuery.SELECT_WEBKIT_LOG_GROUP, params: []) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let time : String = String(cString: sqlite3_column_text(stmt, 0))
                let url : String = String(cString: sqlite3_column_text(stmt, 1))
                let data : WebkitLogData = WebkitLogData(time: time, url: url)
                if(!url.isEmpty && !time.isEmpty) {
                    webkitLogList.append(data)
                }
            }
        }
        
        if(webkitLogList.count > 0) {
            for item in webkitLogList {
                let params = [item.time, item.url]
                SQLite.shared.select(sql: DefineQuery.SELECT_WEBKIT_LOG, params: params) { (stmt: OpaquePointer?) in
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        let date : String = String(cString: sqlite3_column_text(stmt, 0))
                        let function : String = String(cString: sqlite3_column_text(stmt, 1))
                        let params : String = String(cString: sqlite3_column_text(stmt, 2))
                        let description : String = String(cString: sqlite3_column_text(stmt, 3))
                        
                        let log : WebkitLog = WebkitLog(date, function, params, description)
                        item.dataList.append(log)
                    }
                }
            }
            
            webkitLogList[0].isOpen = true
        }
        
        SQLite.shared.close()
        
        return webkitLogList
    }
    
    // 웹킷로그 데이터 모두 삭제
    public static func deleteWebkitLogDataAll() {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.DELETE_WEBKIT_LOG_DATA_ALL)
        SQLite.shared.close()
    }
    
    // 즐겨찾기 테이블에 데이터 입력
    public static func insertBookmarkData(params: [Any]) {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.INSERT_BOOKMARK, params: params)
        SQLite.shared.close()
    }
    
    // 즐겨찾기 데이터 삭제
    public static func deleteBookmarkData(url: String) -> Bool {
        var isDeleted = false

        SQLite.shared.open()
        isDeleted = SQLite.shared.execSQL(sql: DefineQuery.DELETE_BOOKMARK_DATA, params: [url])
        SQLite.shared.close()
        
        return isDeleted
    }
    
    // 즐겨찾기 데이터 모두 삭제
    public static func deleteBookmarkDataAll() {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.DELETE_BOOKMARK_DATA_ALL)
        SQLite.shared.close()
    }
    
    // 해당 URL의 즐겨찾기 여부
    public static func selectBookmarkCntByURL(url: String) -> Bool {
        var isExist = false
        
        SQLite.shared.open()
        SQLite.shared.select(sql: DefineQuery.SELECT_BOOKMARK_CNT_BY_URL, params: [url]) { (stmt: OpaquePointer?) in
            if( sqlite3_step(stmt) == SQLITE_ROW ) {
                let cnt : Int = Int(sqlite3_column_int(stmt, 0))
                isExist = cnt > 0
            }
        }
        SQLite.shared.close()
        
        return isExist
    }
    
    // 즐겨찾기 목록 조회
    public static func selectBookmarkData() -> [BookmarkData] {
        var bookmarkList : [BookmarkData] = []
        
        SQLite.shared.open()
        SQLite.shared.select(sql: DefineQuery.SELECT_BOOKMARK) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let url: String = String(cString: sqlite3_column_text(stmt, 0))
                let title: String = String(cString: sqlite3_column_text(stmt, 1))
                bookmarkList.append(BookmarkData(url: url, title: title))
            }
        }
        SQLite.shared.close()
        
        return bookmarkList
    }
}

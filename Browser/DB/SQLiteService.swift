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
        // 콘솔로그 테이블
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_CONSOLE_LOG_TABLE)
        let tbl2 = SQLite.shared.execSQL(sql: DefineQuery.CREATE_CONSOLE_LOG_TABLE)
        // 웹킷로그 테이블
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_WEBKIT_LOG_TABLE)
        let tbl3 = SQLite.shared.execSQL(sql: DefineQuery.CREATE_WEBKIT_LOG_TABLE)
        // 즐겨찾기 테이블
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_BOOKMARK_TABLE)
        let tbl4 = SQLite.shared.execSQL(sql: DefineQuery.CREATE_BOOKMARK_TABLE)
        
        SQLite.shared.close()
        
        return tbl1 && tbl2 && tbl3 && tbl4
    }
    
    // HISTORY_TBL에 데이터 입력
    public static func insertHistoryData(param: [Any]) {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.INSERT_HISTORY_URL, params: param)
        SQLite.shared.close()
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
    
    // CONSOLE_LOG_TBL
    public static func insertConsoleLogData(params: [Any]) {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.INSERT_CONSOLE_LOG, params: params)
        SQLite.shared.close()
    }
    
    // 콘솔로그 목록 조회
    public static func selectConsoleLogData() -> [ConsoleLogData] {
        var consoleLogList : [ConsoleLogData] = []
        
        SQLite.shared.open()
        SQLite.shared.select(sql: DefineQuery.SELECT_CONSOLE_LOG) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let date : String = String(cString: sqlite3_column_text(stmt, 0))
                let url : String = String(cString: sqlite3_column_text(stmt, 1))
                let message : String = String(cString: sqlite3_column_text(stmt, 2))
                
                let data = ConsoleLogData(date: date, url: url, log: message)
                consoleLogList.append(data)
            }
        }
        SQLite.shared.close()
        
        return consoleLogList
    }
    
    // 콘솔로그 데이터 모두 삭제
    public static func deleteConsoleLogDataAll() {
        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.DELETE_CONSOLE_LOG_DATA_ALL)
        SQLite.shared.close()
    }
    
    // 웹킷로그 테이블에 데이터 입력
    public static func insertWebkitLogData(params: [Any]) {
//        SQLite.shared.open()
//        _ = SQLite.shared.execSQL(sql: DefineQuery.INSERT_WEBKIT_LOG, params: params)
//        SQLite.shared.close()
    }
    
    // 웹킷로그 목록 조회
    public static func selectWebkitLogData() -> [WebkitLogData] {
        var webkitLogList : [WebkitLogData] = []
        SQLite.shared.open()
        SQLite.shared.select(sql: DefineQuery.SELECT_WEBKIT_LOG, params: []) { (stmt: OpaquePointer?) in
            while sqlite3_step(stmt) == SQLITE_ROW {
                let date : String = String(cString: sqlite3_column_text(stmt, 0))
                let function : String = String(cString: sqlite3_column_text(stmt, 1))
                let params : String = String(cString: sqlite3_column_text(stmt, 2))
                let description : String = String(cString: sqlite3_column_text(stmt, 3))

                let data : WebkitLogData = WebkitLogData(date: date, function: function, params: params, description: description)
                webkitLogList.append(data)
            }
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

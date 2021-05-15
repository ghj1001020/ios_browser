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

    // 히스토리 테이블 생성
    public static func createTable() -> Bool {
        var result = false

        SQLite.shared.open()
        _ = SQLite.shared.execSQL(sql: DefineQuery.DROP_HISTORY_TABLE)
        result = SQLite.shared.execSQL(sql: DefineQuery.CREATE_HISTORY_TABLE)
        SQLite.shared.close()
        
        return result
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
}

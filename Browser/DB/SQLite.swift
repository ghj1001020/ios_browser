//
//  SQLite.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/13.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation
import SQLite3

class SQLite {
    
    static let shared = SQLite()    // 싱글톤
    
    public static let DB_VERSION = 12
    private let DB_FILE_NAME = "browser.db"

    private let dbUrl : URL?
    private var dbPointer : OpaquePointer? = nil

    
    private init() {
        do {
            self.dbUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(DB_FILE_NAME)
        }
        catch {
            self.dbUrl = nil
        }
    }
    
    func open() {
        guard sqlite3_open(dbUrl?.path, &dbPointer) == SQLITE_OK else {
            Log.p("SQLITE Open Failed")
            close()
            return
        }
    }
    
    func close() {
        sqlite3_close(dbPointer)
        dbPointer = nil
    }
    
    func execSQL( sql: String, params: [Any]=[] ) -> Bool {
        if( dbUrl == nil || dbPointer == nil ){
            Log.p("dbUrl or dbPointer is nil")
            return false
        }
        
        var result = false
        var stmt : OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, sql, -1, &stmt, nil) == SQLITE_OK  {
            let SQLITE_STATIC = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            for (index, item) in params.enumerated() {
                if( item is Int32 ) {
                    sqlite3_bind_int(stmt, Int32(index+1), item as! Int32)
                }
                else if( item is Int64 ) {
                    sqlite3_bind_int64(stmt, Int32(index+1), item as! Int64)
                }
                else if( item is Double ) {
                    sqlite3_bind_double(stmt, Int32(index+1), item as! Double)
                }
                else {
                    let str = item as! String
                    sqlite3_bind_text(stmt, Int32(index+1), String(str.utf8), -1, SQLITE_STATIC)
                }
            }

            if sqlite3_step(stmt) == SQLITE_DONE  {
                result = true
            }
            else {
                result = false
                let errMsg = String(cString: sqlite3_errmsg(stmt))
                let errCode = Int(sqlite3_errcode(stmt))
                Log.p("SQLITE_DONE failed. \(errMsg) \(errCode)")
            }
        }
        else {
            result = false
            let errMsg = String(cString: sqlite3_errmsg(stmt))
            Log.p("sqlite3_prepare_v2 failed. \(errMsg)")
        }
        
        sqlite3_finalize(stmt)
        
        return result
    }
    
    func select(sql: String, params: [Any]=[], listener: (_ stmt: OpaquePointer?)->Void) {
        if( dbUrl == nil || dbPointer == nil ) {
            LogUtil.p("dbUrl or dbPointer is nil")
            return
        }

        var stmt : OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, sql, -1, &stmt, nil) == SQLITE_OK {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            for (index, item) in params.enumerated() {
                if( item is Int ) {
                    sqlite3_bind_int(stmt, Int32(index+1), Int32(item as! Int) )
                }
                else if( item is Int32 ) {
                    sqlite3_bind_int(stmt, Int32(index+1), item as! Int32)
                }
                else if( item is Int64 ) {
                    sqlite3_bind_int64(stmt, Int32(index+1), item as! Int64)
                }
                else if( item is Double ) {
                    sqlite3_bind_double(stmt, Int32(index+1), item as! Double)
                }
                else {
                    let str = item as! String
                    sqlite3_bind_text(stmt, Int32(index+1), String(str.utf8), -1, SQLITE_TRANSIENT)
                }
            }

            listener(stmt)
            sqlite3_finalize(stmt)
        }
        else {
            LogUtil.p(String(cString: sqlite3_errmsg(dbPointer)))
        }
    }
}

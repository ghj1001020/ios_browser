//
//  DefineQuery.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/12.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation


class DefineQuery {
    
    // 히스토리 테이블 생성
    public static let CREATE_HISTORY_TABLE = "CREATE TABLE IF NOT EXISTS HISTORY_TBL ( " +
                                             "    VISIT_DATE  VARCHAR(14)  NOT NULL ,  " +
                                             "    TITLE       VARCHAR(400)          ,  " +
                                             "    URL         VARCHAR(200) NOT NULL    " +
                                             ");"
    
    // 히스토리 테이블 삭제
    public static let DROP_HISTORY_TABLE = "DROP TABLE IF EXISTS HISTORY_TBL"
    
    // 히스토리 테이블에 데이터 입력
    public static let INSERT_HISTORY_URL = "INSERT INTO HISTORY_TBL( VISIT_DATE , TITLE , URL ) VALUES( ?, ?, ?)"
    
    // 히스토리 테이블 날짜(yyyyMMdd) 목록 조회
    public static let SELECT_HISTORY_DATE_GROUP = "SELECT    DATE " +
                                                  "FROM      ( SELECT SUBSTR(VISIT_DATE, 1, 8) AS DATE" +
                                                  "            FROM   HISTORY_TBL ) " +
                                                  "GROUP  BY DATE " +
                                                  "ORDER  By DATE DESC"
    
    // 히스토리 테이블 날짜(yyyyMMdd)별 방문사이트 목록 조회
    public static let SELECT_HISTORY_URL_BY_DATE = "SELECT   VISIT_DATE , " +
                                                   "         TITLE      , " +
                                                   "         URL          " +
                                                   "FROM     HISTORY_TBL  " +
                                                   "WHERE    SUBSTR(VISIT_DATE, 1, 8)==? " +
                                                   "ORDER BY VISIT_DATE DESC"
    
    // 히스토리 테이블의 모든데이터 삭제
    public static let DELETE_HISTORY_DATA_ALL = "DELETE FROM HISTORY_TBL"
    
    // 히스토리 테이블의 데이터 삭제
    public static let DELETE_HISTORY_DATA = "DELETE FROM HISTORY_TBL " +
                                            "WHERE       VISIT_DATE=?"
    
    // 히스토리 테이블 날짜(yyyyMMdd) 목록 조회
    public static let SELECT_HISTORY_SEARCH_GROUP = "SELECT    DATE " +
                                                    "FROM      ( SELECT SUBSTR(VISIT_DATE, 1, 8) AS DATE" +
                                                    "            FROM   HISTORY_TBL " +
                                                    "            WHERE  TITLE LIKE '%'||?||'%' OR URL LIKE '%'||?||'%' ) " +
                                                    "GROUP  BY DATE " +
                                                    "ORDER  BY DATE DESC"
    
    // 히스토리 테이블의 데이터 검색
    public static let SELECT_HISTORY_SEARCH = "SELECT   VISIT_DATE , " +
                                              "         TITLE      , " +
                                              "         URL          " +
                                              "FROM     HISTORY_TBL  " +
                                              "WHERE    TITLE LIKE '%'||?||'%' OR URL LIKE '%'||?||'%' " +
                                              "     AND SUBSTR(VISIT_DATE, 1, 8)==? " +
                                              "ORDER BY VISIT_DATE DESC"
    
    // 콘솔로그 테이블 생성
    public static let CREATE_CONSOLE_LOG_TABLE = "CREATE TABLE IF NOT EXISTS CONSOLE_LOG_TBL ( " +
                                                 "      LOG_DATE VARCHAR(14)  NOT NULL , " +
                                                 "      URL      VARCHAR(200)          , " +
                                                 "      LOG      VARCHAR(5000)           " +
                                                 ");"
    
    // 콘솔로그 테이블 삭제
    public static let DROP_CONSOLE_LOG_TABLE = "DROP TABLE IF EXISTS CONSOLE_LOG_TBL"
    
    // 콘솔로그 데이터 입력
    public static let INSERT_CONSOLE_LOG = "INSERT INTO CONSOLE_LOG_TBL(LOG_DATE, URL, LOG) VALUES(?, ?, ?)"
    
    // 콘솔로그 데이터 조회
    public static let SELECT_CONSOLE_LOG = "SELECT LOG_DATE, URL, LOG " +
                                           "FROM   CONSOLE_LOG_TBL"
    
    // 콘솔로그 전체 데이터 삭제
    public static let DELETE_CONSOLE_LOG_DATA_ALL = "DELETE FROM CONSOLE_LOG_TBL"
}

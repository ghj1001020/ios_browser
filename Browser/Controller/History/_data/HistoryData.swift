//
//  WebSiteData.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/18.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation


class HistoryData {
    var isOpen : Bool = false
    let date : String
    var dataList : [WebSiteData] = []
    
    init(date: String) {
        self.date = date
    }
    
    init(date: String, isOpen: Bool) {
        self.date = date
        self.isOpen = isOpen
    }
    
    func copy() -> HistoryData {
        let clone = HistoryData(date: date)
        clone.isOpen = isOpen
        clone.dataList = dataList.map({
            $0.copy()
        })
        return clone
    }
}

// 방문한 사이트 정보
struct WebSiteData {
    let date : String
    let title : String
    let url : String
    
    init(date: String, title: String, url: String) {
        self.date = date
        self.title = title
        self.url = url
    }
    
    func copy() -> WebSiteData {
        let clone = WebSiteData(date: date, title: title, url: url)
        return clone
    }
}

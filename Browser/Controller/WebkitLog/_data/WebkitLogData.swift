//
//  WebkitLogData.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/27.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation

class WebkitLogData {
    var isOpen : Bool = false
    let time : String
    let url : String
    var dataList : [WebkitLog] = []
    
    init(time: String, url: String, _ isOpen: Bool=false) {
        self.time = time
        self.url = url
        self.isOpen = isOpen
    }
}

// 방문한 사이트 정보
struct WebkitLog {
    let date : String
    let function : String
    let params : String
    let description : String
    
    init(_ date: String, _ function: String, _ params: String, _ description: String) {
        self.date = date
        self.function = function
        self.params = params
        self.description = description
    }
}

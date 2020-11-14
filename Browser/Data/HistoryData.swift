//
//  HistoryData.swift
//  Browser
//
//  Created by 권혁준 on 2020/11/12.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

class HistoryData : Codable {
    
    var date : String = ""
    var title : String = ""
    var url : String = ""
    
    init( date: String , title: String, url: String ) {
        self.date = date
        self.title = title
        self.url = url
    }
}

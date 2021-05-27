//
//  ConsoleLogData.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/22.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation

class ConsoleLogData {
    let date : String
    let url : String
    let log : String
    
    init(date: String, url: String, log: String) {
        self.date = date
        self.url = url
        self.log = log
    }
}

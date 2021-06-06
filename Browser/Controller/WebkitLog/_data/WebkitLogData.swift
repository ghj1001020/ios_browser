//
//  WebkitLogData.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/27.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation

class WebkitLogData {
    
    let date : String
    let function : String
    let params : String
    let description : String
    
    init(date: String, function: String, params: String, description: String) {
        self.date = date
        self.function = function
        self.params = params
        self.description = description
    }
}

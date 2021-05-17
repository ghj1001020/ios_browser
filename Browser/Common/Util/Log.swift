//
//  Log.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/28.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

class Log {
    
    static func p(_ _message : String? , _file: String=#file, _function: String=#function, _line: Int=#line, _column: Int=#column )
    {
        if( AppConfig.LOG_BLOCK ) {
            return
        }
        
        var fileName = ""
        if let index = _file.lastIndex(of: "/") {
            fileName = String(_file[_file.index(index, offsetBy: 1)..<_file.endIndex])
        }
        let message = _message.nullToString(defaultValue: "")
        
        print( "[\(fileName) , \(_function) , Line:\(_line)] >> \(message)" )
    }
}

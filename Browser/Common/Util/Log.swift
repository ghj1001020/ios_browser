//
//  Log.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/28.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

class Log {
    
    static func p( _tag : String? , _message : String? )
    {
        if( AppConfig.LOG_BLOCK ) {
            return
        }
        
        let tag = _tag.nullToString(defaultValue: "")
        let message = _message.nullToString(defaultValue: "")
        
        print( "[\(tag)] \(message)" )
    }
}

//
//  StringUtil.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/28.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    // null check, to string
    public func nullToString( defaultValue : String = "" ) -> String
    {
        var value : String = ""
        if( self == nil ) {
            value = defaultValue
        }
        else {
            value = self!
        }
        
        return value
    }
}

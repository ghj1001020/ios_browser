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
    
    // nil or "" - true
    public func isEmpty() -> Bool {
        if(self == nil || self!.isEmpty) {
            return true
        }
        return false
    }
}

extension String {
    subscript( bounds: CountableClosedRange<Int> ) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    func substring(from: Int, to: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(start, offsetBy: to-from)
        return String(self[start..<end])
    }
}

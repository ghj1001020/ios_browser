//
//  ColorUtil.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/05.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class BRColor {
    
    // 배경색
    static func background() -> UIColor {
        return colorByString(rgb: "#F2F2F2")
    }
    
    // 상태바 배경색
    static func status() -> UIColor {
        return colorByString(rgb: "#30A9DE")
    }
    
    // 타이틀바 배경색
    static func bgAppBar() -> UIColor {
        return colorByString(rgb: "#A3DAFF")
    }
    
    // 테이블 로그섹션 배경색
    static func bgTableSection() -> UIColor {
        return colorByString(rgb: "#F2F2F2")
    }
    
    
    // 테두리
    static func border() -> UIColor {
        return colorByString(rgb: "#EEEEEE")
    }
    
    // 디바이더
    static func divider() -> UIColor {
        return colorByString(rgb: "#DDDDDD")
    }
    
    // 글자색
    static func text() -> UIColor {
        return colorByString(rgb: "#101010")
    }
    
    static func date() -> UIColor {
        return colorByString(rgb: "#666666")
    }
    
    static func description() -> UIColor {
        return colorByString(rgb: "#888888")
    }

    static func black() -> UIColor {
        return colorByString(rgb: "#000000")
    }
    
    
    // hex int -> UIColor 로 변환
    static func colorByHex(hex:Int , alpha:Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(alpha))
    }
    
    // rgb string -> UIColor 로 변환
    static func colorByString(rgb:String, alpha:Float = 1.0) -> UIColor {
        var _rgb = rgb.uppercased()
        if _rgb.hasPrefix("#") {
            _rgb = _rgb.replacingOccurrences(of: "#", with: "")
        }
        
        // string -> hex int
        var hexValue:UInt64 = 0
        Scanner(string: _rgb).scanHexInt64(&hexValue)

        if _rgb.count == 6 {
            let _red = CGFloat( (hexValue & 0xff0000) >> 16 ) / 255
            let _green = CGFloat( (hexValue & 0x00ff00) >> 8 ) / 255
            let _blue = CGFloat( (hexValue & 0x0000ff) ) / 255
            return UIColor(red: _red, green: _green, blue: _blue, alpha: CGFloat(alpha))
        }
        else {
            return UIColor()
        }
    }
    
}

//
//  Util.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/28.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import UIKit

class Util
{
    // hex -> UIColor 로 변환
    static func uiColorByHex(hex:Int , alpha:Float = 1.0) -> UIColor
    {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r/255.0), green: CGFloat(g/255.0), blue: CGFloat(b/255.0), alpha: CGFloat(alpha))
    }
    
    // URL에서 도메인만 반환
    static func getUrlDomain( _url : String? ) -> String {
        guard let strUrl = _url else {
            return ""
        }
        
        let url = URL(string: strUrl)
        let domain = url?.host ?? ""
        return domain
    }
}

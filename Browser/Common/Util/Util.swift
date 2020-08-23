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
    static let TAG : String = "Util"
    
    
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
    
    // 얼럿 다이얼로그
    static func showAlertDialog( controller: UIViewController , title: String , message: String , action1 : UIAlertAction? , action2 : UIAlertAction? ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if action1 == nil && action2 == nil {
            alert.addAction( UIAlertAction(title: "확인", style: .cancel, handler: nil) )
        }
        else {
            if let action1 = action1 {
                alert.addAction(action1)
            }
            if let action2 = action2 {
                alert.addAction(action2)
            }
        }

        controller.present(alert, animated: true, completion: nil )
        
        return alert
    }
    
    // json string -> dto
    static func jsonStringToDto<T>( type: T.Type , params: String) -> T?  where T:Decodable {
        if params.isEmpty || "{}" == params {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let data : T = try decoder.decode( T.self, from: params.data(using: .utf8)! )
            
            return data
        }
        catch {
            Log.p( _tag: TAG, _message: error.localizedDescription )
            return nil
        }
    }
    
    // dto -> json string
    static func dtoToJsonString<T:Codable>( dto : T? ) -> String {
        if dto == nil {
            return ""
        }
        
        do {
            let encoder = JSONEncoder()
            let jsonData : Data = try encoder.encode(dto)
            let jsonString : String = String(data: jsonData, encoding: .utf8) ?? ""
            
            return jsonString
        }
        catch {
            Log.p(_tag: TAG, _message: error.localizedDescription )
            return ""
        }
    }
}


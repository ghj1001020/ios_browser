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
            Log.p(error.localizedDescription )
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
            Log.p(error.localizedDescription )
            return ""
        }
    }
    
    // parameter query 만들기
    static func makeQueryParameter( params : [String:String]? ) -> String {
        var parameter = ""
        if let _params = params {
            parameter = "?"
            for (index, item) in _params.enumerated() {
                parameter += item.key + "=" + item.value
                
                if( index < _params.count-1 ) {
                    parameter += "&"
                }
            }
            
            parameter = parameter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }

        return parameter
    }
    
    // Date -> String
    static func dateToString( date: Date, format: String ) -> String {
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // date string을 from format -> to format 으로 변환
    static func convertDateFormat( date: String, fromFormat: String, toFormat: String ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        
        guard let fromDate : Date = formatter.date(from: date) else {
            return ""
        }
        
        formatter.dateFormat = toFormat
        return formatter.string(from: fromDate)
    }
    
    // date string에서 요일 구하기 (일~토)
    static func getDayOfWeekFromDateString(date: String, format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = format

        guard let date : Date = formatter.date(from: date) else {
            return ""
        }
        
        return formatter.shortWeekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
    }
}

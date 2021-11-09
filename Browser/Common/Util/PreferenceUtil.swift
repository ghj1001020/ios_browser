//
//  PreferenceUtil.swift
//  Browser
//
//  Created by 권혁준 on 2020/11/10.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

class PreferenceUtil {
        
    private static let pref_key = "WEB_PAGE_HISTORY_"
    
    // 방문한페이지 저장
//    static func saveWebPageHistory( item : HistoryData ) {
//        var historyList : Array<String> = PreferenceUtil.getPrefStringArray(key: pref_key)
//        historyList.append( Util.dtoToJsonString(dto: item) )
//        
//        setPrefStringArray(key: pref_key, value: historyList)
//    }
    
    // 방문한페이지 조회
    static func getWebPageHistory() -> Array<String> {
        return getPrefStringArray(key: pref_key)
    }
    
    
    static func setPrefObject( key : String, value : Any? ) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    static func getPrefObject<T>( key : String , type : T.Type ) -> T? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: key) as? T
    }
    
    static func setPrefString( key : String, value : String? ) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    static func getPrefString( key : String , _ defaultValue : String = "" ) -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key) ?? defaultValue
    }
    
    static func setPrefDictionary( key : String, value : Dictionary<String, String>? ) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    static func getPrefDictionary( key : String ) -> Dictionary<String, String> {
        let userDefaults = UserDefaults.standard
        return userDefaults.dictionary(forKey: key) as? Dictionary<String, String> ?? [String:String]()
    }
    
    static func setPrefArray<T>( key : String, value : Array<T>? ) {
        let _value = value ?? Array<T>()
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(_value, forKey: key)
    }
    
    static func getPrefArray<T>( key : String , type : T.Type ) -> Array<T> {
        let userDefaults = UserDefaults.standard
        return userDefaults.array(forKey: key) as? Array<T> ?? [T]()
    }
    
    static func setPrefStringArray( key : String, value : Array<String>? ) {
        let _value = value ?? Array<String>()

        let userDefaults = UserDefaults.standard
        userDefaults.set(_value, forKey: key)
    }
    
    static func getPrefStringArray( key : String ) -> Array<String> {
        let userDefaults = UserDefaults.standard
        return userDefaults.stringArray(forKey: key) ?? [String]()
    }
}

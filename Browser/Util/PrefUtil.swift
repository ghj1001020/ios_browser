//
//  PrefUtil.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/17.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation

class PrefUtil {
    
    public static let shared = PrefUtil()
    
    private init() {}
    
    
    // 키
    public static let DB_VERSION = "db_version"
    
    
    // Int형
    func setInt(key: String, value: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    func getInt(key: String) -> Int {
        let userDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: key)
    }
    
    // String형
    func setString(key: String, value: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    func getString(key: String, _ defaultValue: String="") -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key) ?? defaultValue
    }
}

//
//  DefaultsUtil.swift
//  Browser
//
//  Created by 권혁준 on 2021/12/01.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation

class DefaultsUtil {
    
    public static let shared = DefaultsUtil()
    
    private init() {}
    
    // 데이터 저장
    func put(_ key: String, _ value: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    func put(_ key: String, _ value: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: key)
    }
    
    // 데이터 조회
    func get(_ key: String, _ defaultValue: Int=0) -> Int {
        let userDefaults = UserDefaults.standard
        if userDefaults.object(forKey: key) == nil {
            return defaultValue
        }
        return userDefaults.integer(forKey: key)
    }
    
    func get(_ key: String, _ defaultValue: String="") -> String {
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: key) ?? defaultValue
    }
}

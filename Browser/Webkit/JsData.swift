//
//  JsData.swift
//  Browser
//
//  Created by 권혁준 on 2020/08/22.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation

struct JsAlertPopupData : Codable {
    var title : String
    var message : String
}

struct JsGetMessageData : Codable {
    var title : String
    var message : String
}

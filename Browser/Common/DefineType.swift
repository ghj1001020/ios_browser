//
//  DefineType.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/19.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation
import UIKit

// 웹사이트 목록 구분 타입
enum WebSiteType : Int {
    case DATE = 0   // 날짜
    case URL = 1    // 방문사이트
}

protocol URLItemProtocol {
    func onDismissViewController(controller: UIViewController)   // 컨트롤러 종료시
    func onUrlClick(url: String)    // URL클릭시
}

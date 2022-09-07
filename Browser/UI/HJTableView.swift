//
//  HJTableView.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/04.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class HJTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    func initLayout() {
        // divider 제거
        self.separatorStyle = .none
        // 클릭허용
        self.isUserInteractionEnabled = true
        self.allowsSelection = true
    }
}

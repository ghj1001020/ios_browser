//
//  LogTableView.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/07.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

// 히스토리 목록 리스너
protocol LogTableSectionDelegate {
    func onSectionClick(section: Int)
}

class LogTableView: UITableView {
    
    public var tableType : Int = 0 {
        didSet {
            
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    func initLayout() {
        
        // 섹션 nib
        let nibSection = UINib(nibName: "LogTableViewSection", bundle: nil)
        self.register(nibSection, forHeaderFooterViewReuseIdentifier: "logSection")
        
        // 셀 nib
        let nibCell = UINib(nibName: "LogTableViewCell", bundle: nil)
        self.register(nibCell, forCellReuseIdentifier: "logCell")
        
        let webkitCell = UINib(nibName: "WebkitLogTableViewCell", bundle: nil)
        self.register(webkitCell, forCellReuseIdentifier: "webkitCell")

        let consoleCell = UINib(nibName: "ConsoleLogTableViewCell", bundle: nil)
        self.register(consoleCell, forCellReuseIdentifier: "consoleCell")

        
        // divider 제거
        self.separatorStyle = .none
        // 클릭허용
        self.isUserInteractionEnabled = true
        self.allowsSelection = true
        // 셀높이 auto resize
        self.rowHeight = UITableView.automaticDimension
        // 섹션높이 auto resize
        self.sectionHeaderHeight = UITableView.automaticDimension
        self.estimatedSectionHeaderHeight = 48
        // 푸터높이 0
        self.sectionFooterHeight = .zero
        self.estimatedSectionFooterHeight = .zero
        // 테이블뷰 하단 여백제거
        self.tableFooterView = UIView(frame: .zero)
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -18, right: 0)
    }
}

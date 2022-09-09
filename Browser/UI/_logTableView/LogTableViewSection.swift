//
//  LogTableViewSection.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/07.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class LogTableViewSection : UITableViewHeaderFooterView {
    
    var section : Int = 0   // 몇번째 섹션인지 인덱스
    var delegate : LogTableSectionDelegate?
    
    @IBOutlet var lbSection: UILabel!
    @IBOutlet var imgArrow: UIImageView!
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initLayout()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    func initLayout() {
        // 클릭이벤트 설정
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onSectionClick))
        addGestureRecognizer(gesture)
    }
    
    @objc func onSectionClick() {
        delegate?.onSectionClick(section: section)
    }
}

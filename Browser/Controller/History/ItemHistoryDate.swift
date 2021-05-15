//
//  ItemHistoryDate.swift
//  Browser
//
//  Created by 권혁준 on 2021/04/25.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation
import UIKit


// 히스토리 목록 리스너
protocol HistoryProtocol {
    func onHistoryDateClick(section: Int)
    func onHistoryUrlClick(section: Int, row: Int)
}

class ItemHistoryDate : UITableViewHeaderFooterView {
    
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var imgArrow: UIImageView!
    
    var delegate : HistoryProtocol?
    var section : Int = 0   // 몇번째 섹션인지 인덱스

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // 클릭이벤트 설정
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onDateClick))
        addGestureRecognizer(gesture)
    }
    
    // Date셀 클릭시 콜백 호출
    @objc func onDateClick(_ sender: UIView) {
        delegate?.onHistoryDateClick(section: section)
    }
}

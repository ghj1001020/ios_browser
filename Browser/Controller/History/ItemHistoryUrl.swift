//
//  ItemHistoryUrl.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/02.
//  Copyright © 2021 권혁준. All rights reserved.
//

import Foundation
import UIKit

class ItemHistoryUrl : UITableViewCell {
    
    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbUrl: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var divider: UIView!
    
    var delegate : HistoryProtocol?
    var section : Int = 0   // 몇번째 섹션인지 인덱스
    var row : Int = 0 // 몇번째 로우인지 인덱스
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selectionStyle = .none
        
        // 클릭이벤트 설정
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onUrlClick))
        addGestureRecognizer(gesture)
    }
    
    @objc func onUrlClick(_ sender: UIView) {
        delegate?.onHistoryUrlClick(section: section, row: row)
    }
}

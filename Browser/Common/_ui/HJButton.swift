//
//  HJButton.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/15.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class HJButton: UIButton {

    @IBInspectable public var borderColor : UIColor = UIColor.lightGray
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        renderUI()
    }
    
    
    func renderUI() {
        // 버튼라인 색상
        layer.borderColor = borderColor.cgColor
    }
}

//
//  BRImageButton.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/15.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class BRImageButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? BRColor.effect() : UIColor.clear
            if(isHighlighted) {
                super.isHighlighted = false
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    
    func initLayout() {
        self.setTitle("", for: .normal)
    }
}

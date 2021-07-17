//
//  HJCheckBox.swift
//  Browser
//
//  Created by 권혁준 on 2021/07/14.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class HJCheckBox : UIButton {
    private var _isChecked : Bool = false
    @IBInspectable public var isChecked : Bool {
        set {
            _isChecked = newValue
            renderImage()
        }
        get {
            return _isChecked
        }
    }
    @IBInspectable private var imgCheck : UIImage = UIImage()
    @IBInspectable private var imgUncheck : UIImage = UIImage()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        renderImage()
    }
    
    func renderImage() {
        if( _isChecked ) {
            self.setImage(imgCheck, for: .normal)
        }
        else {
            self.setImage(imgUncheck, for: .normal)
        }
    }
}

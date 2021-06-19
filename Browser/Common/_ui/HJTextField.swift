//
//  HJTextField.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/19.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class HJTextField: UITextField {

    @IBInspectable public var borderColor : UIColor = UIColor.lightGray
    @IBInspectable public var paddingTop : CGFloat = 0
    @IBInspectable public var paddingLeft : CGFloat = 0
    @IBInspectable public var paddingBottom : CGFloat = 0
    @IBInspectable public var paddingRight : CGFloat = 0
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        renderUI()
    }
    
    func renderUI() {
        // 버튼라인 색상
        layer.borderColor = borderColor.cgColor
    }
        
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight))
    }
}

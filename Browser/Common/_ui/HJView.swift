//
//  HJView.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/01.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

//@IBDesignable
class HJView: UIView {

    @IBInspectable public var topLeft : Bool = false {
        didSet {
            
        }
    }
    @IBInspectable public var topRight : Bool = false {
        didSet {
            
        }
    }
    @IBInspectable public var bottomLeft : Bool = false {
        didSet {
            
        }
    }
    @IBInspectable public var bottomRight : Bool = false {
        didSet {

        }
    }
    @IBInspectable public var cornerRadius : CGFloat = 0 {
        didSet {
            
        }
    }
    @IBInspectable public var borderColor : UIColor = UIColor.clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 라운드 마스크
        if #available(iOS 11.0, *) {
            updateCornerRound()
        }
        else {
            updateCornerRoundOld()
        }
        
        layer.borderColor = borderColor.cgColor
    }
    
    // 라운드
    func updateCornerRoundOld() {
        var options = UIRectCorner()
        if topLeft {
            options.formUnion(.topLeft)
        }
        if topRight {
            options.formUnion(.topRight)
        }
        if bottomLeft {
            options.formUnion(.bottomLeft)
        }
        if bottomRight {
            options.formUnion(.bottomRight)
        }
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: options, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
    
    // 라운드
    @available(iOS 11.0, *)
    func updateCornerRound() {
        var maskLayer = CACornerMask()
        if topLeft {
            maskLayer.formUnion(.layerMinXMinYCorner)
        }
        if topRight {
            maskLayer.formUnion(.layerMaxXMinYCorner)
        }
        if bottomLeft {
            maskLayer.formUnion(.layerMinXMaxYCorner)
        }
        if bottomRight {
            maskLayer.formUnion(.layerMaxXMaxYCorner)
        }
        
        layer.maskedCorners = maskLayer
        layer.cornerRadius = cornerRadius
    }
}

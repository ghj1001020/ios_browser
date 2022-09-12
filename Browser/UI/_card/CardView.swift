//
//  CardView.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/10.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class CardView: UIView {

    @IBInspectable public var topLeft : Bool = true
    @IBInspectable public var topRight : Bool = true
    @IBInspectable public var bottomLeft : Bool = true
    @IBInspectable public var bottomRight : Bool = true
    @IBInspectable public var cornerRadius : CGFloat = 15

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.borderWidth = 1
        layer.borderColor = BRColor.divider().cgColor
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

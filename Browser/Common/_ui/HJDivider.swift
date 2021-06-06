//
//  HJDivider.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/04.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class HJDivider: UIView {
    
    @IBInspectable public var dashLine : Int = 7
    @IBInspectable public var dashGap : Int = 3
    @IBInspectable public var dashColor : UIColor = UIColor.lightGray
    

    override func layoutSubviews() {
        // 디바이더
        let path = CGMutablePath()
        let point = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: self.frame.height)]
        path.addLines(between: point)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [NSNumber(value: dashLine), NSNumber(value: dashGap)]
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }

}

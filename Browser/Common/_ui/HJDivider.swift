//
//  HJDivider.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/04.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class HJDivider: UIView {
    
    @IBInspectable public var lineColor : UIColor = UIColor.lightGray   // 선색
    @IBInspectable public var isLine : Bool = true
    @IBInspectable public var dashLine : Int = 7
    @IBInspectable public var dashGap : Int = 3

    
    override func layoutSubviews() {
        if( isLine ) {
            drawLine()
        }
        else {
            drawDashLine()
        }
    }
    

    // 실선그리기
    public func drawLine() {
        layer.backgroundColor = lineColor.cgColor
    }
    
    // 점선그리기
    public func drawDashLine() {
        let point = [CGPoint(x: 0, y: 0), CGPoint(x: self.frame.width, y: self.frame.height)]
        let path = CGMutablePath()
        path.addLines(between: point)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = lineColor.cgColor
        // 수평
        if( self.frame.width >= self.frame.height ) {
            shapeLayer.lineWidth = self.frame.height
        }
        // 수직
        else {
            shapeLayer.lineWidth = self.frame.width
        }

        shapeLayer.lineDashPattern = [NSNumber(value: dashLine), NSNumber(value: dashGap)]
        shapeLayer.path = path
        
        layer.addSublayer(shapeLayer)
    }

}

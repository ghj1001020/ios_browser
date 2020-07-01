//
//  CommUI.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/28.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import UIKit


class CommUILabel : UILabel {
    // 패딩
    var tempX : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    open var padding: UIEdgeInsets {
        set {
            tempX = newValue
        }
        get {
            return tempX
        }
    }
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override open var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += padding.left + padding.right
        intrinsicContentSize.height += padding.top + padding.bottom
        return intrinsicContentSize
    }
}


extension UILabel
{
    // 글자간격
    func setLetterSpacing(value:Double = 1.15)
    {
        guard let t = text else {
            return
        }
        
        let attributedString = NSMutableAttributedString(string: t)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length-1))
        attributedText = attributedString
    }
    
    // 글자앞에 아이콘 추가
    func setTextWithIcon( _text : String? , _icon : String)
    {
        guard let t = _text else {
            return
        }
        
        let attributedString = NSMutableAttributedString()
        
        // 아이콘 추가
        let _icon = UIImage(named: _icon)
        if let icon = _icon {
            let attachIcon = NSTextAttachment(image: icon)
            attachIcon.bounds = CGRect(x: 0, y: (font.capHeight-icon.size.height)/2, width: icon.size.width, height: icon.size.height)
            attributedString.append(NSAttributedString(attachment: attachIcon))
        }
        // 글자 추가
        attributedString.append(NSAttributedString(string: t))

        sizeToFit()
        attributedText = attributedString
    }
}

extension UIButton {
    
    // 클릭시 배경색 변경 애니메이션
    func addClickAnimation( color : CGColor ) {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = color
        animation.duration = 0.5
        
        self.layer.add(animation, forKey: "ColorPulse")
    }
}

//
//  AlertUtil.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/07.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class AlertUtil {
    
    // 얼럿
    public class Alert {
        var alert : UIAlertController
        
        var controller : UIViewController
        var positiveText : String? = nil
        var negativeText : String? = nil
        var positiveDelegate : (()->Void)? = nil
        var negativeDelegate : (()->Void)? = nil

        
        init(_ controller: UIViewController, _ title: String="", _ message: String="") {
            self.alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            self.controller = controller
        }
        
        func setTitle(_ text: String) {
            self.alert.title = text
        }
        
        func setMessage(_ text: String) {
            self.alert.message = text
        }
        
        func setPositive(_ text: String="확인", _ delegate: (()->Void)?=nil) {
            self.positiveText = text
            self.positiveDelegate = delegate
            
            if(positiveText != nil) {
                let action = UIAlertAction(title: positiveText, style: .default) { (action: UIAlertAction) in
                    if let callback = self.positiveDelegate {
                        callback()
                    }
                }
                alert.addAction(action)
            }
        }
        
        func setNegative(_ text: String="취소", _ delegate: (()->Void)?=nil) {
            self.negativeText = text
            self.negativeDelegate = delegate
            
            if( negativeText != nil) {
                let action = UIAlertAction(title: negativeText, style: .cancel) { (action: UIAlertAction) in
                    if let callback = self.negativeDelegate {
                        callback()
                    }
                }
                alert.addAction(action)
            }
        }
        
        func show() {
            if(negativeText == nil && positiveText == nil) {
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
            }
            
            controller.present(alert, animated: true, completion: nil)
        }
    }

    
    // 하단 액션시트
    public class ActionSheet {
        
        var controller : UIViewController
        var title : String = ""
        var message : String = ""
        var actionList : [UIAlertAction] = []
        
        init(_ controller: UIViewController, _ title: String="", _ message: String="") {
            self.controller = controller
            self.title = title
            self.message = message
        }
        
        func addAction(_ text: String="확인", _ style: UIAlertAction.Style = .default, _ delegate: (()->Void)?=nil) {
            let action = UIAlertAction(title: text, style: style) { (action: UIAlertAction) in
                if let callback = delegate {
                    callback()
                }
            }
            actionList.append(action)
        }
        
        func show(_ style: UIAlertController.Style = .alert) {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            for action in actionList {
                alert.addAction(action)
            }
            
            let action = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(action)
            
            controller.present(alert, animated: true, completion: nil)
        }
    }
}

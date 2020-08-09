//
//  MoreDialogController.swift
//  Browser
//
//  Created by 권혁준 on 2020/08/02.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import UIKit

protocol MoreDialogProtocol {
    func onMoreMenuClick( requestId : Int , selected : Int )
}

class MoreDialogController : UIViewController {
    
    @IBOutlet var dim: UIView!
    @IBOutlet var viewDialog: UIView!
    var listener : MoreDialogProtocol? = nil
    var requestId : Int = -1
    
    
    override func viewDidLoad() {
        // 딤클릭하면 다이얼로그 닫기
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDim(geusture:)) )
        dim.addGestureRecognizer(tap)
        dim.isUserInteractionEnabled = true
        
        // 다이얼로그 애니메이션
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { ()->Void in
                self.viewDialog.transform = CGAffineTransform(translationX: 0, y: -self.viewDialog.frame.height)
            }, completion: nil)
        }
    }

    @IBAction func onMenuCookie(_ sender: UIButton) {
        listener?.onMoreMenuClick(requestId: requestId, selected: DefineCode.MORE_MENU_COOKIE)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMenuPrint(_ sender: UIButton) {
        listener?.onMoreMenuClick(requestId: requestId, selected: DefineCode.MORE_MENU_PRINT)
        dismiss(animated: true, completion: nil)
    }
    
    // 딤클릭 > 다이얼로그 닫기
    @objc func tapDim( geusture : UITapGestureRecognizer ) {
        dismiss(animated: true, completion: nil)
    }
}

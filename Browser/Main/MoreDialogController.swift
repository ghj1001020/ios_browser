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
    func onMoreMenuClick( selected : Int )
}

class MoreDialogController : UIViewController {
        
    @IBOutlet var dim: UIView!
    @IBOutlet var viewDialog: UIView!
    @IBOutlet var btnPcMobileMode: UIButton!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var listener : MoreDialogProtocol? = nil
    
    
    override func viewDidLoad() {
        // 다이얼로그 애니메이션
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { ()->Void in
                self.viewDialog.transform = CGAffineTransform(translationX: 0, y: -self.viewDialog.frame.height)
            }, completion: nil)
        }
        
        initLayout()
    }
    
    func initLayout() {
        // 딤클릭하면 다이얼로그 닫기
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDim(geusture:)) )
        dim.addGestureRecognizer(tap)
        dim.isUserInteractionEnabled = true
        
        // 모바일/데스크탑모드 이미지
        if( delegate.isMobile ) {
            btnPcMobileMode.setBackgroundImage(UIImage(named: "ic_toolbar_desktop"), for: .normal)
        }
        else {
            btnPcMobileMode.setBackgroundImage(UIImage(named: "ic_toolbar_mobile"), for: .normal)
        }
    }

    @IBAction func onMenuCookie(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        listener?.onMoreMenuClick(selected: DefineCode.MORE_MENU_COOKIE)
    }
    
    @IBAction func onMenuPrint(_ sender: UIButton) {
        listener?.onMoreMenuClick(selected: DefineCode.MORE_MENU_PRINT)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMenuPcM(_ sender: UIButton) {
        listener?.onMoreMenuClick(selected: DefineCode.MORE_MENU_PC_MOBILE_MODE)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onMenuHistory(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        listener?.onMoreMenuClick(selected: DefineCode.MORE_MENU_HISTORY)
    }
    
    @IBAction func onMenuConsoleLog(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        listener?.onMoreMenuClick(selected: DefineCode.MORE_MENU_CONSOLE_LOG)
    }
    
    
    
    // 딤클릭 > 다이얼로그 닫기
    @objc func tapDim( geusture : UITapGestureRecognizer ) {
        dismiss(animated: true, completion: nil)
    }
}

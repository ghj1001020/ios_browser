//
//  SettingViewController.swift
//  Browser
//
//  Created by 권혁준 on 2022/10/05.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    var userAgent = ""
    var appVersion: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    var isMobile = false
    
    @IBOutlet var lbAppVersion: UILabel!
    @IBOutlet var lbUserAgent: UILabel!
    @IBOutlet var lbMode: UILabel!
    @IBOutlet var swiMode: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isMobile = appDelegate.isMobile

        setAppBar(.BACK)
        setAppBarTitle("설정")
        setStatusBar()
        
        lbAppVersion.text = "v\(appVersion)"
        lbUserAgent.text = userAgent
        changeMobileMode()
        swiMode.addTarget(self, action: #selector(swiModeValueChanged), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        baseProtocol?.onDismiss(vc: self, data: ["isChanged" : !(isMobile == appDelegate.isMobile)])
    }
    
    @objc func swiModeValueChanged() {
        isMobile = !isMobile
        changeMobileMode()
    }
    
    func changeMobileMode() {
        if(isMobile) {
            lbMode.text = "ON"
            
        }
        else {
            lbMode.text = "OFF (PC)"
            swiMode.isOn = false
        }
    }
}

//
//  CookieTableViewCell.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/16.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class CookieTableViewCell : UITableViewCell {
    
    @IBOutlet var lbKey: UILabel!
    @IBOutlet var lbValue: UILabel!
    @IBOutlet var divider: HJDivider!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selectionStyle = .none
    }
    
    func initUI() {
        lbKey.font = UIFont.systemFont(ofSize: 15)
        lbKey.textColor = BRColor.subText()
        lbValue.font = UIFont.systemFont(ofSize: 16)
        lbValue.textColor = BRColor.text()
    }
}

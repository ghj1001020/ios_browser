//
//  LogTableViewCell.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/07.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class LogTableViewCell : UITableViewCell {

    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbContent: UILabel!
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
        lbDate.textColor = BRColor.date()
        lbTitle.textColor = BRColor.text()
        lbContent.textColor = BRColor.text()
    }
}

//
//  ConsoleLogTableViewCell.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/12.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class ConsoleLogTableViewCell: UITableViewCell {

    @IBOutlet var lbDate: UILabel!
    @IBOutlet var lbConsole: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initLayout()
    }
    
    func initLayout() {
        self.selectionStyle = .none
        self.backgroundColor = BRColor.background()
    }
    
    func initUI() {
        lbDate.textColor = BRColor.date()
        lbConsole.textColor = BRColor.text()
    }
}

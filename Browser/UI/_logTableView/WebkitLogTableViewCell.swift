//
//  WebkitLogTableViewCell.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/10.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit


class WebkitLogTableViewCell : UITableViewCell {
    
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbFunction: UILabel!
    @IBOutlet var lbParam: UILabel!
    @IBOutlet var lbDesc: UILabel!
    
    
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
        self.backgroundColor = UIColor.white
    }
    
    func initUI() {
        self.lbTime.textColor = BRColor.date()
        self.lbFunction.textColor = BRColor.text()
        self.lbParam.textColor = BRColor.text()
        self.lbDesc.textColor = BRColor.description()
    }
}

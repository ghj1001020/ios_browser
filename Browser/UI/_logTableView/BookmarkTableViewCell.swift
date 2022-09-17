//
//  BookmarkTableViewCell.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/17.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class BookmarkTableViewCell : UITableViewCell {
 
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbUrl: UILabel!
    @IBOutlet var divider: HJDivider!
    
    func initI() {
        lbTitle.numberOfLines = 0
        lbUrl.numberOfLines = 0
        lbTitle.textColor = BRColor.text()
        lbUrl.textColor = BRColor.text()
    }
}

//
//  StatusBar.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/09.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class StatusBar: UIView {
    
    var parent: UIView
    
    init(parentView: UIView) {
        self.parent = parentView
        super.init(frame: .zero)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        self.parent = UIView()
        super.init(coder: coder)
    }
    
    func initLayout() {
        self.backgroundColor = BRColor.status()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func getConstrains() -> [NSLayoutConstraint] {
        let leading = self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0)
        let trailing = self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0)
        let top = self.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0)
        let height = UIApplication.shared.statusBarFrame.size.height
        let bottom = self.heightAnchor.constraint(equalToConstant: height)
        return [leading, trailing, top, bottom]
    }
}

//
//  BRAppBar.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/05.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit


enum BRAppBarType {
    case NORMAL
    case BACK
}

protocol BRAppBarProtocol {
    func onBackButtonClick()
    func onDeleteButtonClick()
}

class BRAppBar: UIView {
    
    public var delegate : BRAppBarProtocol? = nil
    
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func loadXib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else  {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func initUI(_ type: BRAppBarType) {
        self.backgroundColor = BRColor.bgAppBar()
        self.lbTitle.textColor = BRColor.black()
        self.lbTitle.font = self.lbTitle.font.withSize(19)
        
        if(type == .BACK) {
            btnDelete.isHidden = true
        }
        else {
            btnDelete.isHidden = false
        }
    }
    
    func setTitle(_ title: String) {
        lbTitle.text = title
    }
    
    @IBAction func onBackButtonClick(_ sender: UIButton) {
        delegate?.onBackButtonClick()
    }
    
    @IBAction func onDeleteButtonClick(_ sender: UIButton) {
        delegate?.onDeleteButtonClick()
    }
    
}

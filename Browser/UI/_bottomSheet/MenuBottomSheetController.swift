//
//  MenuBottomSheetController.swift
//  Browser
//
//  Created by 권혁준 on 2022/09/04.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

protocol MenuDialogProtocol {
    func onMenuBottomSheetClick(_ selected : String )
}

class MenuBottomSheetController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var listener : MenuDialogProtocol? = nil
    
    @IBOutlet var tblMenu: HJTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMenu.delegate = self
        tblMenu.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DefineCode.MENU.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? MenuBottomSheetTableCell else {
            return UITableViewCell()
        }
        
        let img = DefineCode.MENU[indexPath.row]["img"]
        let name = DefineCode.MENU[indexPath.row]["name"]
        
        cell.imgMenu.image = UIImage(named: img!)
        cell.lbMenu.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        let code = DefineCode.MENU[indexPath.row]["code"].nullToString()
        listener?.onMenuBottomSheetClick(code)
    }
}

//
//  IndexViewController.swift
//  Browser
//
//  Created by 권혁준 on 2020/11/22.
//  Copyright © 2020 권혁준. All rights reserved.
//

import UIKit

class IndexViewController: UIViewController, UITextFieldDelegate {
    
    private let TAG : String = "IndexViewController"
    
    @IBOutlet var edit_search: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventHideKeyboard()
        initLayout()
    }
    
    func initLayout() {
        edit_search.delegate = self
        edit_search.returnKeyType = .search // 엔터키를 검색모양으로
        
        createTable()
    }
    
    func createTable() {
        let dbVersion: Int = PrefUtil.shared.getInt(key: PrefUtil.DB_VERSION)
        if( dbVersion != SQLite.DB_VERSION ) {
            SQLiteService.createTable()
            PrefUtil.shared.setInt(key: PrefUtil.DB_VERSION, value: SQLite.DB_VERSION)
        }
    }
    
    @IBAction func onSearchBtn(_ sender: UIButton) {
        indexPageSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        indexPageSearch()
        return true
    }
    
    func indexPageSearch() {
        var search : String = edit_search.text ?? ""
        if search.isEmpty {
            search = DefineCode.DEFAULT_PAGE
            edit_search.text = search
        }
            
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "Main") as? MainViewController else {
            return
        }
        
        controller.modalPresentationStyle = .fullScreen
        
        controller.indexSearch = search
        self.present(controller, animated: false, completion: nil )
        
        edit_search.text = ""
    }
}

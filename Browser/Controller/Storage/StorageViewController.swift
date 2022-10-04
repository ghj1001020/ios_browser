//
//  StorageViewController.swift
//  Browser
//
//  Created by 권혁준 on 2022/10/04.
//  Copyright © 2022 권혁준. All rights reserved.
//

import Foundation
import UIKit

class StorageViewController : BaseViewController, UITableViewDataSource , UITableViewDelegate  {
    
    var localStorage = ""
    var sessionStorage = ""
    var localList : [(key:String , value:String)] = []
    var sessionList : [(key:String , value:String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppBar(.BACK)
        setAppBarTitle("Storage")
        setStatusBar()
        
        initData()
    }
    
    func initData() {
        // 로컬스토리지
        if let localData = localStorage.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: localData, options: .fragmentsAllowed) as? [String: String] {
                    for (key, value) in json {
                        localList.append((key: key, value: value))
                    }
                }
            }
            catch {
                if(!localStorage.isEmpty) {
                    localList.append((key: "", value: localStorage))
                }
                Log.p( error.localizedDescription )
            }
        }
        
        if(localList.isEmpty) {
            localList.append((key: "", value: ""))
        }
        
        // 세션스토리지
        if let sessionData = sessionStorage.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: sessionData, options: .fragmentsAllowed) as? [String: String] {
                    for (key, value) in json {
                        sessionList.append((key: key, value: value))
                    }
                }
            }
            catch {
                if(!sessionStorage.isEmpty) {
                    sessionList.append((key: "", value: sessionStorage))
                }
                Log.p( error.localizedDescription )
            }
        }
        
        if(sessionList.isEmpty) {
            sessionList.append((key: "", value: ""))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? localList.count : sessionList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "logSection") as? LogTableViewSection else {
            return UITableViewHeaderFooterView()
        }
        
        header.section = section
        header.lbSection.text = (section == 0) ? "Local Storage" : "Session Storage"
        header.imgArrow.isHidden = true
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cookieCell") as? CookieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.initUI()
        cell.lbKey.text = (indexPath.section == 0) ? localList[indexPath.row].key : sessionList[indexPath.row].key
        cell.lbValue.text = (indexPath.section == 0) ? localList[indexPath.row].value : sessionList[indexPath.row].value
        cell.divider.isHidden = (indexPath.section == 0) ? indexPath.row == localList.count-1 : indexPath.row == sessionList.count-1

        return cell
    }
}

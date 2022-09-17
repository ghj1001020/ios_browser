//
//  CookieViewController.swift
//  Browser
//
//  Created by 권혁준 on 2020/08/09.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class CookieViewController : BaseViewController , UITableViewDataSource , UITableViewDelegate {
    
    var cookieData : [(key:String , value:String)] = []
    
    @IBOutlet var cookieTable: UITableView!
    var url : String? = nil    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppBar(.BACK)
        setAppBarTitle("쿠키")
        setStatusBar()
        
        getCookies()
    }
    
    // 해당 URL의 쿠키 가져오기
    func getCookies() {
        guard let url = url else {
            return
        }
        
        if #available(iOS 11.0, *) {
            let cookieStore : WKHTTPCookieStore = WKWebsiteDataStore.default().httpCookieStore
            cookieStore.getAllCookies { cookies in
                for cookie in cookies {
                    if( url.contains( cookie.domain ) ) {
                        let name = cookie.name
                        let value = cookie.value
                        
                        self.cookieData.append( (key: name, value: value) )
                        Log.p("\(cookie.domain) .. \(name) .. \(value)")
                    }
                }
                self.cookieTable.reloadData()
            }
        }
        else {
            guard let url = URL(string: url) else {
                return
            }
            
            guard let cookies : [HTTPCookie] = HTTPCookieStorage.shared.cookies(for: url ) else {
                return
            }
            
            for cookie in cookies {
                let name = cookie.name
                let value = cookie.value

                self.cookieData.append( (key: name, value: value) )
                Log.p("\(cookie.domain) .. \(name) .. \(value)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cookieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cookieCell") as? CookieTableViewCell else {
            return UITableViewCell()
        }
        
        cell.initUI()
        
        let key : String = (cookieData[indexPath.row]).key
        let value : String = (cookieData[indexPath.row]).value
        
        cell.lbKey.text = key
        cell.lbValue.text = value
        cell.divider.isHidden = indexPath.row == cookieData.count-1 ? true : false
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}

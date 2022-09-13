//
//  ConsoleLogViewController.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/22.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class ConsoleLogViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet var logTable: UITableView!
    
    public var consoleLogList : [ConsoleLogData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppBar()
        setAppBarTitle("콘솔로그")
        setStatusBar()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consoleLogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "consoleCell") as? ConsoleLogTableViewCell else {
            return UITableViewCell()
        }
        
        cell.initUI()
                
        let date = Util.convertDateFormat(date: consoleLogList[indexPath.row].date, fromFormat: "yyyyMMddHHmmss", toFormat: "yyyy-MM-dd HH:mm:ss")
        cell.lbDate.text = date
        cell.lbConsole.text = consoleLogList[indexPath.row].log
        
        return cell
    }
}

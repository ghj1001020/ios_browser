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
    
    private var logData : [ConsoleLogData] = {
        return SQLiteService.selectConsoleLogData()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppBar()
        setAppBarTitle("콘솔로그")
        setStatusBar()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "consoleLogCell") as? ConsoleLogTableCell else {
            return UITableViewCell()
        }
                
        let date = Util.convertDateFormat(date: logData[indexPath.row].date, fromFormat: "yyyyMMddHHmmss", toFormat: "yyyy-MM-dd HH:mm:ss")
        cell.lbDate.text = date
        cell.lbUrl.text = logData[indexPath.row].url
        cell.lbLog.text = logData[indexPath.row].log
        
        return cell
    }
    
    
    // 전체 콘솔로그 삭제
    override func onDeleteButtonClick() {
        SQLiteService.deleteConsoleLogDataAll()
        self.logData = SQLiteService.selectConsoleLogData()
        self.logTable.reloadData()
    }
}

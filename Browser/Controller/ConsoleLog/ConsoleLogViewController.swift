//
//  ConsoleLogViewController.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/22.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class ConsoleLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet var logTable: UITableView! 
    
    private var logData : [ConsoleLogData] = {
        return SQLiteService.selectConsoleLogData()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 비어있는 셀의 divider 제거
        logTable.tableFooterView = UIView()
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    // 전체 콘솔로그 삭제
    @IBAction func onConsoleLogDeleteAll(_ sender: UIButton) {
        let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) in
            SQLiteService.deleteConsoleLogDataAll()
            self.logData = SQLiteService.selectConsoleLogData()
            self.logTable.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        _ = Util.showAlertDialog(controller: self, title: "", message: "전체 삭제 하시겠습니까?", action1: cancel, action2: ok)
    }
    
}

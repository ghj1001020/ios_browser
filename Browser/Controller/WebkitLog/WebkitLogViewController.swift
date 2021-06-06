//
//  WebkitLogViewController.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/30.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class WebkitLogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 웹킷로그 목록 데이터
    private var webkitLogList : [WebkitLogData] = {
        return SQLiteService.selectWebkitLogData()
    }()
    @IBOutlet var tblWebkitLog: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webkitLogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "webkitLogCell") as? WebkitLogTableCell else {
            return UITableViewCell()
        }
        
        let date = Util.convertDateFormat(date: webkitLogList[indexPath.row].date, fromFormat: "yyyyMMddHHmmss", toFormat: "yyyy-MM-dd HH:mm:ss")
        cell.lbDate.text = date
        cell.lbFunction.text = webkitLogList[indexPath.row].function
        cell.lbParams.text = webkitLogList[indexPath.row].params
        cell.lbDescription.text = webkitLogList[indexPath.row].description
        
        return cell
    }
    
    @IBAction func onWebkitLogDeleteAll(_ sender: UIButton) {
        let ok = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) in
            SQLiteService.deleteWebkitLogDataAll()
            self.webkitLogList = SQLiteService.selectWebkitLogData()
            self.tblWebkitLog.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        _ = Util.showAlertDialog(controller: self, title: "", message: "전체 삭제 하시겠습니까?", action1: cancel, action2: ok)
    }
}

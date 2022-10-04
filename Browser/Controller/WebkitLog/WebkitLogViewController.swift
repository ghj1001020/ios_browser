//
//  WebkitLogViewController.swift
//  Browser
//
//  Created by 권혁준 on 2021/05/30.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

class WebkitLogViewController: BaseViewController, LogTableSectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // 웹킷로그 목록 데이터
    private var webkitLogList : [WebkitLogData] = {
        return SQLiteService.selectWebkitLogData()
    }()
    
    @IBOutlet var tblWebkitLog: LogTableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppBar()
        setAppBarTitle("웹킷로그")
        setStatusBar()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return webkitLogList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webkitLogList[section].isOpen ? webkitLogList[section].dataList.count : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "logSection") as? LogTableViewSection else {
            return UITableViewHeaderFooterView()
        }
        
        header.section = section
        header.delegate = self
        header.lbSection.text = webkitLogList[section].url
        header.imgArrow.image = webkitLogList[section].isOpen ? UIImage(named: "ic_arrow_u") : UIImage(named: "ic_arrow_d")
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "webkitCell") as? WebkitLogTableViewCell else {
            return UITableViewCell()
        }
        
        cell.initUI()
        
        let data = webkitLogList[indexPath.section].dataList[indexPath.row]
        let date = Util.convertDateFormat(date: data.date, fromFormat: "yyyyMMddHHmmss", toFormat: "yyyy-MM-dd HH:mm:ss")
        cell.lbTime.text = date
        cell.lbFunction.text = data.function
        cell.lbParam.text = data.params
        cell.lbDesc.text = data.description
        
        return cell
    }
    
    func onSectionClick(section: Int) {
        webkitLogList[section].isOpen = !webkitLogList[section].isOpen
        tblWebkitLog.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    override func onDeleteButtonClick() {
        SQLiteService.deleteWebkitLogDataAll()
        self.webkitLogList = SQLiteService.selectWebkitLogData()
        self.tblWebkitLog.reloadData()
    }
}

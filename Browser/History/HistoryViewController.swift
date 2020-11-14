//
//  HistoryViewController.swift
//  Browser
//
//  Created by 권혁준 on 2020/11/08.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let TAG = "CookieViewController"
    private let historyList : Array<String> = {
        return PreferenceUtil.getWebPageHistory().reversed()
    }()
    
    @IBOutlet var tableHistory: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableHistory.tableFooterView = UIView()
        tableHistory.dataSource = self
        tableHistory.delegate = self
    }
    
    @IBAction func onBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell") as? HistoryTableCell else {
            return UITableViewCell()
        }
        
        let item : HistoryData? = Util.jsonStringToDto(type: HistoryData.self, params: historyList[indexPath.row])
        
        cell.txtTitle.text = item?.title ?? ""
        cell.txtUrl.text = item?.url ?? ""
                
        return cell
    }
    
}

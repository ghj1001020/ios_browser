//
//  HistoryViewController.swift
//  Browser
//
//  Created by 권혁준 on 2020/11/08.
//  Copyright © 2020 권혁준. All rights reserved.
//

import Foundation
import UIKit


class HistoryViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, HistoryProtocol, UISearchBarDelegate {
    
    private let TAG = "HistoryViewController"
        
    private var historyList : [HistoryData] = {
        return SQLiteService.selectHistoryDatesAndUrls()
    }()
    var delegate : URLItemProtocol?
    
    @IBOutlet var tableHistory: UITableView!
//    @IBOutlet var btnMore: UIButton!
    
    // 검색바
    let searchController = UISearchController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppBar()
        setAppBarTitle("방문한 페이지")
        
        // 섹션 nib
        let nibSection = UINib(nibName: "ItemHistoryDate", bundle: nil)
        tableHistory.register(nibSection, forHeaderFooterViewReuseIdentifier: "historyDate")
        // 셀 nib
        let nibCell = UINib(nibName: "ItemHistoryUrl", bundle: nil)
        tableHistory.register(nibCell, forCellReuseIdentifier: "historyUrl")
        
        // 셀높이 auto resize
        tableHistory.rowHeight = UITableView.automaticDimension
        tableHistory.estimatedRowHeight = 88
        // 섹션높이 auto resize
        tableHistory.sectionHeaderHeight = UITableView.automaticDimension
        tableHistory.estimatedSectionHeaderHeight = 48
        // 푸터높이 0
        tableHistory.sectionFooterHeight = 0
        tableHistory.estimatedSectionFooterHeight = 0
        // 비어있는 셀의 divider 제거
        tableHistory.tableFooterView = UIView()
        // 헤더뷰 - 검색바
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        tableHistory.tableHeaderView = searchController.searchBar
        
        // 검색바 > 최상위뷰 설정
        self.definesPresentationContext = true
        
        // 검색바 > 최초진입시 검색바 안보이게 위로 올림
        tableHistory.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.height)

        tableHistory.dataSource = self
        tableHistory.delegate = self
        
        if #available(iOS 11.0, *) {
            self.navigationItem.hidesSearchBarWhenScrolling = true
        }

        // 이미지를 작게 보여주기 위해 버튼에 패딩추가
//        btnMore.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchController.dismiss(animated: false, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return historyList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "historyDate") as? ItemHistoryDate else {
            return UITableViewHeaderFooterView()
        }
        
        let historyDate = historyList[section].date
        let date = Util.convertDateFormat(date: historyDate, fromFormat: "yyyyMMdd", toFormat: "yyyy-MM-dd")
        let dayOfWeek = "(\(Util.getDayOfWeekFromDateString(date: historyDate, format: "yyyyMMdd")))"
        header.section = section
        header.delegate = self
        header.lbDate.text = "\(date) \(dayOfWeek)"
        header.imgArrow.image = historyList[section].isOpen ? UIImage(named: "ic_arrow_u") : UIImage(named: "ic_arrow_d")
        
        return header
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyList[section].isOpen ? historyList[section].dataList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historyUrl") as? ItemHistoryUrl else {
            return UITableViewCell()
        }
        
        cell.section = indexPath.section
        cell.row = indexPath.row
        cell.delegate = self
  
        let date = historyList[indexPath.section].dataList[indexPath.row].date
        cell.lbDate.text = Util.convertDateFormat(date: date, fromFormat: "yyyyMMddHHmmss", toFormat: "yyyy-MM-dd HH:mm:ss")
        cell.lbUrl.text = historyList[indexPath.section].dataList[indexPath.row].url
        cell.lbTitle.text = historyList[indexPath.section].dataList[indexPath.row].title
        
        if( indexPath.row >= historyList[indexPath.section].dataList.count-1 ) {
            cell.divider.isHidden = true
        }
        
        return cell
    }
    
    // 주어진 행을 편집할수 있는지 여부
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 편집 > 삭제
        if( editingStyle == .delete ) {
            let date = historyList[indexPath.section].dataList[indexPath.row].date
            let isDeleted = SQLiteService.deleteHistoryData(date: date)
            if( isDeleted ) {
                tableHistory.beginUpdates()
                historyList[indexPath.section].dataList.remove(at: indexPath.row)
                // 날짜밑에 데이터가 없으면 날짜섹션도 삭제
                if( historyList[indexPath.section].dataList.count == 0 ){
                    historyList.remove(at: indexPath.section)
                    tableHistory.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
                tableHistory.deleteRows(at: [indexPath], with: .fade)
                
                tableHistory.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 테이블뷰 헤더섹션 > 날짜클릭
    func onHistoryDateClick(section: Int) {
        historyList[section].isOpen = !historyList[section].isOpen
        tableHistory.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // 테이블뷰 셀 > URL클릭
    func onHistoryUrlClick(section: Int, row: Int) {
        let url : String = historyList[section].dataList[row].url
        delegate?.onUrlClick(url: url)
        dismiss(animated: true, completion: nil)
    }
    
    // 전체삭제
    override func onMoreButtonClick() {
        let alert = AlertUtil.ActionSheet(self)
        alert.addAction("전체 삭제") {
            SQLiteService.deleteHistoryDataAll()
            self.historyList.removeAll()
            self.tableHistory.reloadData()
        }
        alert.show()
    }
    
    // 검색어 입력시 콜백
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }

        if searchText.isEmpty {
            historyList = SQLiteService.selectHistoryDatesAndUrls()
            tableHistory.reloadData()
        }
        else {
            historyList = SQLiteService.selectHistorySearch(search: searchText)
            tableHistory.reloadData()
        }
    }
}

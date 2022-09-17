//
//  BookmarkViewController.swift
//  Browser
//
//  Created by 권혁준 on 2021/07/15.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit


class BookmarkViewController : BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblBookmark: UITableView!
    
    // 즐겨찾기 목록 데이터
    private var bookmarkData : [BookmarkData] = {
        return SQLiteService.selectBookmarkData()
    }()
    // 클릭프로토콜
    var delegate: URLItemProtocol? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppBar()
        setAppBarTitle("북마크")
        setStatusBar()
    }
    
    override func onBackButtonClick() {
        delegate?.onDismissViewController(controller: self)
        dismiss(animated: true, completion: nil)
    }
    
    override func onDeleteButtonClick() {
        let alert = AlertUtil.ActionSheet(self)
        alert.addAction("전체 삭제") {
            SQLiteService.deleteBookmarkDataAll()
            self.bookmarkData.removeAll()
            self.tblBookmark.reloadData()
        }
        alert.show()
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bookmarkCell") as? BookmarkTableViewCell else {
            return UITableViewCell()
        }
        
        cell.initUI()
        
        cell.lbUrl.text = bookmarkData[indexPath.row].url
        cell.lbTitle.text = bookmarkData[indexPath.row].title
        cell.divider.isHidden = indexPath.row == bookmarkData.count-1 ? true : false
        return cell
    }
    
    // 테이블뷰 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url: String = bookmarkData[indexPath.row].url
        if( !url.isEmpty ) {
            delegate?.onUrlClick(url: url)
        }
        dismiss(animated: true, completion: nil)
    }
    
    // 주어진 행을 편집할수 있는지 여부
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 주어진 행 편집
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 삭제
        if editingStyle == .delete {
            let alert = AlertUtil.Alert(self, "", "삭제 하시겠습니까?")
            alert.setPositive("확인") {
                let url: String = self.bookmarkData[indexPath.row].url
                let isDeleted = SQLiteService.deleteBookmarkData(url: url)
                if( isDeleted ) {
                    self.tblBookmark.beginUpdates()
                    self.bookmarkData.remove(at: indexPath.row)
                    self.tblBookmark.deleteRows(at: [indexPath], with: .fade)
                    self.tblBookmark.endUpdates()
                }
            }
            alert.setNegative()
            alert.show()
        }
    }
}

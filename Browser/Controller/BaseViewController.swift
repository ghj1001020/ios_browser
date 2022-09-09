//
//  BaseViewController.swift
//  Browser
//
//  Created by 권혁준 on 2022/08/14.
//  Copyright © 2022 권혁준. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BRAppBarProtocol {
    
    @IBOutlet var titleBarView: UIView!
    
    // 앱바
    private var titleBar: BRAppBar? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // 앱바 설정
    func setAppBar() {
        guard let xib = Bundle.main.loadNibNamed("BRAppBar", owner: self, options: nil)?.first as? BRAppBar else  {
            return
        }
        
        xib.frame = self.titleBarView.bounds
        xib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        titleBar = xib
        titleBar?.initUI()
        titleBar?.delegate = self
        self.titleBarView.addSubview(titleBar!)
    }
    
    // 타이틀명 변경
    func setAppBarTitle(_ title: String) {
        self.titleBar?.setTitle(title)
    }

    // 이동할 컨트롤러
    func controller<T:UIViewController>(type: T.Type, name: String, id: String, bundle: Bundle?=nil) -> T? {
        let storyboard : UIStoryboard = UIStoryboard(name: name, bundle: bundle)
        if #available(iOS 13.0, *) {
            guard let controller = storyboard.instantiateViewController(identifier: id) as? T else {
                return nil;
            }
            return controller;
        }
        else {
            guard let controller = storyboard.instantiateViewController(withIdentifier: id) as? T else {
                return nil;
            }
            return controller;
        }
    }
    
    // 컨트롤러 이동
    func present(_ controller: UIViewController?) {
        if(controller != nil) {
            controller!.modalPresentationStyle = .fullScreen
            self.present(controller!, animated: true, completion: nil)
        }
    }
    
    // 바텀시트 이동
    func presentDialog(_ content: UIViewController?) {
        if(content != nil) {
            let controller = BottomSheetController(contentController: content!)
            controller.modalPresentationStyle = .overFullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    // 뒤로가기
    func onBackButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    // 더보기
    func onDeleteButtonClick() {}
}

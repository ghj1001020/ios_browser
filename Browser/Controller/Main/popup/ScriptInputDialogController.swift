//
//  ScriptInputDialogController.swift
//  Browser
//
//  Created by 권혁준 on 2021/06/10.
//  Copyright © 2021 권혁준. All rights reserved.
//

import UIKit

protocol ScriptInputDialogProtocol {
    func onScriptInputExecute(script: String)
}

class ScriptInputDialogController: UIViewController, UITextViewDelegate {
        
    @IBOutlet var tvScript: HJTextView!
    var currentTextView : UITextView? = nil   // 현재 포커스된 텍스트필드
    
    var delegate : ScriptInputDialogProtocol? = nil
    
    
    override func viewDidLoad() {
        // dim
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5 )
        
        hideKeyboardWhenTapView()
        
        // 키보드 show 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드 hide 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tvScript.delegate = self
    }

    // 바깥뷰 터치시 키보드 내리기
    func hideKeyboardWhenTapView() {
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        viewTap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(viewTap)
    }
    
    // 키보드가 열리는 콜백
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        guard let currentTextView = self.currentTextView else {
            return
        }
        
        let tfBottom : CGFloat = currentTextView.convert(currentTextView.bounds, to: self.view).maxY
        let keyboardTop = self.view.frame.height - keyboardSize.height
        // 텍스트필드가 키보드보다 밑에 있으면 전체뷰를 키보드 높이만큼 올려준다
        if( tfBottom >= keyboardTop ) {
//            self.view.frame.origin.y = 0 - keyboardSize.height
            self.view.frame.origin.y = 0 - (tfBottom - (self.view.frame.height - (keyboardSize.height + 50)))
        }
    }
    
    // 키보드가 닫히는 콜백
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    // 키보드 내리기
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // 텍스트뷰 포커스시작 콜백
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.currentTextView = textView
    }
    
    // 텍스트뷰 포커스종료 콜백
    func textViewDidEndEditing(_ textView: UITextView) {
        self.currentTextView = textView
    }
    
    @IBAction func onCancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onOk(_ sender: UIButton) {
        delegate?.onScriptInputExecute(script: tvScript.text)
        dismiss(animated: true, completion: nil)
    }
    
}

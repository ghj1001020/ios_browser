//
//  MainViewController.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/22.
//  Copyright © 2020 권혁준. All rights reserved.
//

import UIKit
import WebKit


class MainViewController : UIViewController , UITextFieldDelegate {
    
    
    private let TAG : String = "MainViewController"
    
    
    var wv_main: WKWebView!
    @IBOutlet var view_web: UIView!
    @IBOutlet var lbWebTitle: UILabel!
    @IBOutlet var pgWebLoadingBar: UIProgressView!
    @IBOutlet var editUrl: UITextField!
    @IBOutlet var viewTxtMode: UIView!
    @IBOutlet var viewEditMode: UIView!
    @IBOutlet var dim: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    
    
    var jsBridge : JsBridge!
    var isEditMode : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }
    
    func initLayout() {
        // txt_mode 클릭 설정
        let tapEditMode = UITapGestureRecognizer(target: self, action: #selector(onTapChangeToEditMode(gesture:)) )
        lbWebTitle.addGestureRecognizer(tapEditMode)
        lbWebTitle.isUserInteractionEnabled = true
        
        // url textfield
        editUrl?.delegate = self
        
        // dim 클릭 설정
        let tapDim = UITapGestureRecognizer(target: self, action: #selector(onTapDim(gesture:)) )
        dim.addGestureRecognizer(tapDim)
        dim.isUserInteractionEnabled = true
        
        // 웹뷰
        jsBridge = JsBridge()
        let config = jsBridge.initJsBridge()
        wv_main = WKWebView(frame: CGRect(x: 0, y: 0, width: view_web.frame.width, height: view_web.frame.height), configuration: config)
        view_web.addSubview(wv_main)    // 웹뷰 추가
        wv_main?.uiDelegate = self  // JS 이벤트 콜백
        wv_main?.navigationDelegate = self  // 웹페이지의 start, loading, finish, error 콜백
        wv_main?.autoresizingMask = [.flexibleWidth, .flexibleHeight]   // 뷰의 크기가 변경되면 서브뷰의 크기를 자동으로 조정
        wv_main?.backgroundColor = UIColor.white    // 웹뷰 여백또는 배경을 흰색으로
        wv_main?.isOpaque = true    // 웹뷰 배경 불투명하게
        // 웹뷰 프로그레스
        wv_main?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)    // .new - 값이 변경될때마다 이벤트를 받음
        
        // 기본 웹페이지 로딩
        loadUrl(_url: DefineCode.DEFAULT_PAGE )
    }
    
    // 웹뷰 url 로딩
    func loadUrl( _url : String? ) {
        guard var strUrl = _url else {
            return
        }
        
        if !strUrl.contains("://") {
            strUrl = "https://" + strUrl
        }
        
        guard let url = URL(string: strUrl ) else {
            return
        }
        
        let urlRequest = URLRequest(url: url )
        wv_main?.load( urlRequest )
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let _progress = wv_main?.estimatedProgress  // 진행정도
            guard let progress = _progress else {
                return
            }
            
            if( progress >= 1.0 ) {
                showEditMode(isEdit: false)
            }
            else {
                showEditMode(isEdit: true)
            }
            
            showWebViewLoadingBar(isShow: true, _progress: progress)
        }
    }
    
    // 웹뷰 로딩바 show/hide
    func showWebViewLoadingBar( isShow : Bool , _progress : Double?) {
        guard let progress = _progress else {
            return
        }
        
        if( progress >= 1 ) {
            pgWebLoadingBar.isHidden = true
            pgWebLoadingBar.progress = 0
            return
        }
        
        if( isShow ) {
            pgWebLoadingBar.isHidden = false
            if( progress >= 0 ) {
                pgWebLoadingBar.progress = Float(progress)
            }
        }
        else {
            pgWebLoadingBar.isHidden = true
            pgWebLoadingBar.progress = 0
        }
    }
    
    // 웹뷰 새로고침
    @IBAction func onWebViewRefresh(_ sender: UIButton) {
        sender.addClickAnimation( color: UIColor.init(red: 146/255.0, green: 204/255.0, blue: 243/255.0, alpha: 1.0).cgColor )
        wv_main?.reload()
    }
    
    // edit mode 로 변경
    @objc func onTapChangeToEditMode( gesture : UITapGestureRecognizer ) {
        changeToEditMode(isEdit: true)
    }
    
    // edit mode <-> txt mode
    func changeToEditMode( isEdit : Bool ) {
        if( isEdit ) {
            viewTxtMode.isHidden = true
            viewEditMode.isHidden = false
            
            showKeyboard(isShow: true)
            editUrl.selectAll(nil)
        }
        else {
            viewTxtMode.isHidden = false
            viewEditMode.isHidden = true
            
            showKeyboard(isShow: false)
            editUrl.text = wv_main.url?.absoluteString
        }
        
        isEditMode = isEdit
    }
    
    // edit url delete
    @IBAction func onDeleteEditUrl(_ sender: UIButton) {
        editUrl?.text = ""
    }
    
    // edit url enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == editUrl {
            loadUrl(_url: editUrl.text)
            changeToEditMode(isEdit: false)
            return false
        }
        return true
    }
    
    // edit mode show/hide
    func showEditMode( isEdit : Bool ) {
        if( isEdit ) {
            viewTxtMode.isHidden = true
            viewEditMode.isHidden = false
        }
        else {
            viewTxtMode.isHidden = false
            viewEditMode.isHidden = true
        }
        
        isEditMode = isEdit
    }
    
    // show/hide keyboard
    func showKeyboard( isShow : Bool ) {
        if( isShow ) {
            dim.isHidden = false
            editUrl.becomeFirstResponder()
        }
        else {
            dim.isHidden = true
//            editUrl?.resignFirstResponder() // 키보드 숨김
            self.view.endEditing(true)
        }
    }
    
    // dim 클릭시 키보드내림
    @objc func onTapDim( gesture: UITapGestureRecognizer ) {
        changeToEditMode(isEdit: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dim.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dim.isHidden = true
    }
    
    
    // 이전페이지로 이동
    @IBAction func onToolbarPrevPage(_ sender: UIButton) {
        Log.p(_tag: TAG, _message: "onToolbarPrevPage")
        guard let wvMain = wv_main else {
            return
        }
        
        if( wvMain.canGoBack ) {
            wvMain.goBack()
        }
    }
    
    // 다음페이지로 이동
    @IBAction func onToolbarNextPage(_ sender: UIButton) {
        Log.p(_tag: TAG, _message: "onToolbarNextPage")
        guard let wvMain = wv_main else {
            return
        }
        
        if( wvMain.canGoForward ) {
            wvMain.goForward()
        }
    }
    
    // 기본페이지로 이동
    @IBAction func onToolbarHomePage(_ sender: UIButton) {
        Log.p(_tag: TAG, _message: "onToolbarHomePage")
        
        let defaultPage = DefineCode.DEFAULT_PAGE
        loadUrl(_url: defaultPage)
    }
    
    // 북마크로 이동
    @IBAction func onToolbarBookmark(_ sender: UIButton) {
        Log.p(_tag: TAG, _message: "onToolbarBookmark")
    }
    
    // 설정으로 이동
    @IBAction func onToolbarMore(_ sender: UIButton) {
        Log.p(_tag: TAG, _message: "onToolbarMore")
    }
    
    
    // 웹뷰 앞으로/뒤로가기 버튼 UI
    func changePageMoveButton() {
        guard let wvMain = wv_main else {
            return
        }
        
        // 뒤로가기 버튼
        if( wvMain.canGoBack ) {
            btnBack.isHidden = false
        }
        else {
            btnBack.isHidden = true
        }
        
        // 앞으로가기 버튼
        if( wvMain.canGoForward ) {
            btnNext.isHidden = false
        }
        else {
            btnNext.isHidden = true
        }
    }
    
    
    // todo 테스트 하드코딩
    @IBAction func onTestPage(_ sender: UIButton) {
//        loadUrl(_url: "https://m.help.kt.com/store/s_KtStoreSearch.do")
        loadUrl(_url: "https://m.help.kt.com/store/s_KtStoreAgreement.do")
    }
    
}

// WKUIDelegate - 웹페이지 대신 네이티브에서 사용자 인터페이스를 표시하는 메서드 제공
extension MainViewController : WKUIDelegate , WKNavigationDelegate {
    
    // window open
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return nil
    }

    // alert()
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        Log.p(_tag: TAG, _message: "alert : " + message)
        
        let alert = UIAlertController(title: "" , message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인" , style: .default , handler: { _ in
            completionHandler()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // confirm()
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        Log.p(_tag: TAG, _message: "confirm : " + message)
        
        let alert = UIAlertController(title: "" , message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인" , style: .default , handler: { _ in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // textInput()
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        
    }
    
    // 웹컨텐츠가 로드되기 시작
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Log.p(_tag: TAG, _message: "didStartProvisionalNavigation")
        
        showEditMode(isEdit: true)
        
        // 프로그레스바 표시
        showWebViewLoadingBar( isShow: true, _progress: 0 )
        
        // 타이틀에 url 표시
        let url : String? = webView.url?.absoluteString
        lbWebTitle.text = url
        editUrl.text = url
    }

    // 웹 리다이렉션
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        Log.p(_tag: TAG, _message: "didReceiveServerRedirectForProvisionalNavigation")
        
        // 타이틀에 url 표시
        let url : String? = webView.url?.absoluteString
        lbWebTitle.text = url
        editUrl.text = url
        
        changePageMoveButton()
    }
    
    // 웹뷰에서 컨텐츠를 받기 시작
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Log.p(_tag: TAG, _message: "didCommit")
    }
    
    // 웹 로드 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Log.p(_tag: TAG, _message: "didFinish")
        
        showEditMode(isEdit: false)
        
        // 프로그레스바 숨김
        showWebViewLoadingBar( isShow: false, _progress: 0 )
        
        // 타이틀에 url 표시
        let url : String? = webView.url?.absoluteString
        lbWebTitle.setTextWithIcon(_text: Util.getUrlDomain(_url: url), _icon: "ic_lock")
        editUrl.text = url
        
        changePageMoveButton()
    }

    // 웹컨텐츠 프로세스 종료
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        Log.p(_tag: TAG, _message: "webViewWebContentProcessDidTerminate")
    }
    
    // 웹 탐색중 에러
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 웹컨텐츠 로드중 에러
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    // 웹탐색을 허용할지 취소할지 결정
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // 응답이 완료된후 웹탐색을 허용할지 취소할지 결정
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}

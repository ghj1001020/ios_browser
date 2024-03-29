//
//  MainViewController.swift
//  Browser
//
//  Created by 권혁준 on 2020/03/22.
//  Copyright © 2020 권혁준. All rights reserved.
//

import UIKit
import WebKit


class MainViewController : BaseViewController , UITextFieldDelegate , MenuDialogProtocol, ScriptInputDialogProtocol, BaseProtocol {
    
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
    @IBOutlet var chkBookmark: HJCheckBox!
    @IBOutlet var tblSite: UITableView!
    
    // 시작페이지
    public static var WEBVIEW_LOAD_URL = ""
    public static var WEBVIEW_LOAD_TIME = ""
    
    var jsBridge : JsBridge!
    var isEditMode : Bool = false
    var indexSearch : String = ""
    var isTestPage : Bool = false
    
    var START_TIME : Double = 0 // 웹뷰로드 시간
    
    var yPosition : CGFloat = 0.0
        
    // URL 타이틀바 높이
    @IBOutlet var conUrlBarHeight: NSLayoutConstraint!
    // 바텀바 높이
    @IBOutlet var conBottomMenuHeight: NSLayoutConstraint!
    // URL검색박스 뷰
    @IBOutlet var siteView: UIView!
    // 북마크 목록
    public var bookmarkList : [BookmarkData] = []
    // 히스토리 목록
    public var historyList : [WebSiteData] = {
        return SQLiteService.selectHistoryUrl()
    }()
    // 히스토리 검색 목록
    public var historySearchList : [WebSiteData] = []
    // 에디트모드 > 즐겨찾기 or 히스토리
    public var isBookmarkMode : Bool = true
    
    // 콘솔로그 목록
    public var consoleLogList : [ConsoleLogData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBar()
        initData()
        initLayout()
    }
    
    func initData() {
        setBookmarkList()
    }
    
    func initLayout() {
        btnNext.isHidden = true
        
        // txt_mode 클릭 설정
        let tapEditMode = UITapGestureRecognizer(target: self, action: #selector(onTapChangeToEditMode(gesture:)) )
        lbWebTitle.addGestureRecognizer(tapEditMode)
        lbWebTitle.isUserInteractionEnabled = true
        
        // url textfield
        editUrl?.delegate = self
        editUrl?.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        
        // dim 클릭 설정
        let tapDim = UITapGestureRecognizer(target: self, action: #selector(onTapDim(gesture:)) )
        dim.addGestureRecognizer(tapDim)
        dim.isUserInteractionEnabled = true
        
        // 웹뷰
        jsBridge = JsBridge()
        let config = jsBridge.initJsBridge( listener: self )
        wv_main = WKWebView(frame: CGRect(x: 0, y: 0, width: view_web.frame.width, height: view_web.frame.height), configuration: config)
        view_web.addSubview(wv_main)    // 웹뷰 추가
        wv_main?.uiDelegate = self  // JS 이벤트 콜백
        wv_main?.navigationDelegate = self  // 웹페이지의 start, loading, finish, error 콜백
        wv_main?.autoresizingMask = [.flexibleWidth, .flexibleHeight]   // 뷰의 크기가 변경되면 서브뷰의 크기를 자동으로 조정
        wv_main?.backgroundColor = UIColor.white    // 웹뷰 여백또는 배경을 흰색으로
        wv_main?.isOpaque = true    // 웹뷰 배경 불투명하게
        wv_main?.scrollView.delegate = self
        // 웹뷰 프로그레스
        wv_main?.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)    // .new - 값이 변경될때마다 이벤트를 받음
        
        // 기본 웹페이지 로딩
        if(isTestPage) {
            let htmlPath = Bundle.main.path(forResource: "BridgePage", ofType: "html", inDirectory: "www")

            if(htmlPath != nil) {
                let htmlUrl = URL(fileURLWithPath: htmlPath!)
                let request = URLRequest(url: htmlUrl)
                wv_main?.load(request)
            }
        }
        else {
            loadUrl(_url: indexSearch )
        }
    }
    
    // 웹뷰 url 로딩
    func loadUrl( _url : String? ) {
        if( _url.isEmpty()) {
            return
        }

        var strUrl : String = _url!
        if !(strUrl.starts(with: "http://") || strUrl.starts(with: "https://")) {
            strUrl = "https://" + strUrl
        }
        
        guard let url = URL(string: strUrl ) else {
            return
        }
        
        let urlRequest = URLRequest(url: url )
        wv_main?.load( urlRequest )
    }
    
    // 웹뷰 파일 url 로딩
    func loadFileUrl( htmlUrl : URL? , params : [String:String]? ) {
        var parameter = ""
        if let _params = params {
            parameter = "?"
            for (index, item) in _params.enumerated() {
                parameter += item.key + "=" + item.value
                
                if( index < _params.count-1 ) {
                    parameter += "&"
                }
            }
            
            parameter = parameter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }

        guard let url = URL(string: parameter, relativeTo: htmlUrl) else {
            return
        }

        let urlRequest = URLRequest(url: url)
        wv_main?.load( urlRequest )
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let _progress = wv_main?.estimatedProgress  // 진행정도
            guard let progress = _progress else {
                return
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
    
    // 즐겨찾기 선택/해제
    @IBAction func onBookmarkSelect(_ sender: HJCheckBox) {
        if let item = wv_main.backForwardList.currentItem {
            let url = item.url.absoluteString
            let title = item.title ?? ""

            sender.isChecked = !sender.isChecked
            if( sender.isChecked ) {
                SQLiteService.insertBookmarkData(params: [url, title])
            }
            else {
                _ = SQLiteService.deleteBookmarkData(url: url)
            }
            setBookmarkList()
        }
    }
    
    
    // 웹뷰 새로고침
    @IBAction func onWebViewRefresh(_ sender: UIButton) {
        sender.addClickAnimation( color: UIColor.init(red: 146/255.0, green: 204/255.0, blue: 243/255.0, alpha: 1.0).cgColor )
        
        if wv_main.url == nil {
            if !(editUrl.text?.isEmpty ?? true) {
                loadUrl(_url: editUrl.text )
            }
        }
        else {
            wv_main?.reload()
        }
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
            siteView.isHidden = false
            dim.isHidden = false
            
            showKeyboard(isShow: true)
            editUrl.selectAll(nil)
        }
        else {
            viewTxtMode.isHidden = false
            viewEditMode.isHidden = true
            siteView.isHidden = true
            dim.isHidden = true
            
            showKeyboard(isShow: false)
            editUrl.text = wv_main.url?.absoluteString
        }
        
        isEditMode = isEdit
    }
    
    // edit cancel
    @IBAction func onCancelEdit(_ sender: UIButton) {
        changeToEditMode(isEdit: false)
    }
    
    // edit url delete
    @IBAction func onDeleteEditUrl(_ sender: UIButton) {
        editUrl?.text = ""
        tblSite.reloadData()
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
    
    // show/hide keyboard
    func showKeyboard( isShow : Bool ) {
        if( isShow ) {
            editUrl.becomeFirstResponder()
        }
        else {
            editUrl?.resignFirstResponder() // 키보드 숨김
            self.view.endEditing(true)
        }
    }
    
    // dim 클릭시 키보드내림
    @objc func onTapDim( gesture: UITapGestureRecognizer ) {
        changeToEditMode(isEdit: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isBookmarkMode = true
        tblSite.reloadData()
    }
    
    // 텍스트필드 변경시마다 호출
    @objc func textFieldChanged(_ sender: UITextField) {
        DispatchQueue.global().sync {
            let text = sender.text ?? ""
            if(text.isEmpty) {
                isBookmarkMode = true
                self.tblSite.reloadData()
            }
            else {
                isBookmarkMode = false
                self.searchHistoryList(text)
                self.tblSite.reloadData()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    // 북마크 목록
    func setBookmarkList() {
        bookmarkList = SQLiteService.selectBookmarkData()
    }
    
    // 히스토리 목록 검색
    func searchHistoryList(_ search: String) {
        let _search = search.lowercased()
        historySearchList.removeAll()
        for data in historyList {
            if(data.url.contains(_search) || data.title.contains(_search)) {
                historySearchList.append(data)
            }
        }
    }
    
    // 이전페이지로 이동
    @IBAction func onToolbarPrevPage(_ sender: UIButton) {
        guard let wvMain = wv_main else {
            return
        }
        
        if( wvMain.canGoBack ) {
            wvMain.goBack()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // 다음페이지로 이동
    @IBAction func onToolbarNextPage(_ sender: UIButton) {
        guard let wvMain = wv_main else {
            return
        }
        
        if( wvMain.canGoForward ) {
            wvMain.goForward()
        }
    }
    
    // 기본페이지로 이동
    @IBAction func onToolbarHomePage(_ sender: UIButton) {
        let defaultPage = DefineCode.DEFAULT_PAGE
        loadUrl(_url: defaultPage)
    }
    
    // 북마크로 이동
    @IBAction func onToolbarBookmark(_ sender: UIButton) {
        let controller: BookmarkViewController? = controller(type: BookmarkViewController.self, name: "Bookmark", id: "bookmarkViewController", bundle: nil)
        controller?.delegate = self
        present(controller)
    }
    
    // 설정으로 이동
    @IBAction func onToolbarMore(_ sender: UIButton) {
        let bottomSheet : MenuBottomSheetController? = controller(type: MenuBottomSheetController.self, name: "MenuBottomSheetController", id: "menuBottomSheet", bundle: nil)
        bottomSheet?.listener = self
        self.presentDialog(bottomSheet)
    }
    
    
    // 웹뷰 앞으로/뒤로가기 버튼 UI
    func changePageMoveButton() {
        guard let wvMain = wv_main else {
            return
        }
        
        // 앞으로가기 버튼
        if( wvMain.canGoForward ) {
            btnNext.isHidden = false
        }
        else {
            btnNext.isHidden = true
        }
    }
    
    func getWillMovePageStep( isBack : Bool ) -> Int? {
        let historyList : WKBackForwardList = wv_main.backForwardList
        var move : Int? = nil
        
        if( isBack ) {
            for index in stride(from: historyList.backList.count, through: 0, by: -1)   {
                let itemUrl = historyList.backList[index].url.absoluteString

                if !itemUrl.starts(with: "file:///") && !itemUrl.contains("ErrorPage.html") {
                    move = index
                    break
                }
            }
        }
        else {
            for index in 0..<historyList.forwardList.count {
                let itemUrl = historyList.forwardList[index].url.absoluteString
                
                if !itemUrl.starts(with: "file:///") && !itemUrl.contains("ErrorPage.html") {
                    move = index
                    break
                }
            }
        }
        
        Log.p("move=\(move)")
        return move
    }
    
    
    // todo 테스트 하드코딩
    @IBAction func onTestPage(_ sender: UIButton) {
//        loadUrl(_url: "https://m.help.kt.com/store/s_KtStoreSearch.do")
//        loadUrl(_url: "https://m.help.kt.com/store/s_KtStoreAgreement.do")
        
//        let cookieStore : WKHTTPCookieStore = WKWebsiteDataStore.default().httpCookieStore
//        cookieStore.getAllCookies { cookies in
//            for cookie in cookies {
//                let name = cookie.name
//                let value = cookie.value
//                Log.p(_tag: self.TAG, _message: "\(cookie.domain) .. \(name) .. \(value)")
//            }
//        }
        
//        guard let url = wv_main?.url else {
//            return
//        }
//
//        guard let cookies : [HTTPCookie] = HTTPCookieStorage.shared.cookies(for: url ) else {
//            return
//        }
//
//        for cookie in cookies {
//            Log.p(_tag: TAG, _message: "\(cookie.name) ... \(cookie.value)")
//        }
        
//        let htmlPath = Bundle.main.path(forResource: "BridgePage", ofType: "html", inDirectory: "www")
        let htmlPath = Bundle.main.path(forResource: "BridgePage", ofType: "html", inDirectory: "www")

        guard let path = htmlPath else {
            return
        }

        let htmlUrl = URL(fileURLWithPath: path)

        let request = URLRequest(url: htmlUrl)
        wv_main?.load(request)
//
////        loadUrl(_url: "https://itunes.apple.com/kr/app/%EB%A7%88%EC%9D%B4-%EC%BC%80%EC%9D%B4%ED%8B%B0/id355838434?mt=8")
        
//        let storyboard : UIStoryboard = UIStoryboard(name: "ErrorDialog", bundle: nil)
//        guard let controller = storyboard.instantiateViewController(withIdentifier: "ErrorDialog" ) as? ErrorDialogController else
//        {
//            return
//        }
//
//        controller.modalPresentationStyle = .overCurrentContext // 컨텐츠가 다른 뷰 컨트롤러의 컨텐츠 위에 표시
//
//        self.present(controller, animated: false, completion: nil)

    }
    
    // todo 테스트 하드코딩
    @IBAction func onAppCall(_ sender: Any) {
        onWebMessageReturn()
    }
    
    
    // 웹뷰에서 파일 다운로드
    func wkWebViewFileDownload( type : Int , url : URL ) {
        
        let task = URLSession.shared.downloadTask(with: url) { (_url: URL?, _response: URLResponse?, _error: Error?) in
            
            guard let _response = _response as? HTTPURLResponse else {
                return
            }
            
            guard let _url = _url else {
                return
            }
            
            Log.p("statusCode= \(_response.statusCode)")
            
            if( _response.statusCode != 200 ) {
                return
            }
            
            do {
                var documentUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                documentUrl = documentUrl.appendingPathComponent( _response.suggestedFilename ?? _url.lastPathComponent )
                
                if( FileManager.default.fileExists(atPath: documentUrl.path) ) {
                    try FileManager.default.removeItem(at: documentUrl)
                }
                try FileManager.default.moveItem(at: _url, to: documentUrl)
                
                if( type == DefineCode.URL_DOWNLOAD_IMG ) {
                    let image : UIImage? = UIImage(data: try Data(contentsOf: documentUrl))
                    if let image = image {
                        // 사진라이브러리에 저장
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }
                else if( type == DefineCode.URL_DOWNLOAD_FILE ) {
                    self.showFileDownloadViewController(documentUrl)
                }
            }
            catch {
                Log.p("error=\(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // 파일다운로드 UIActivityViewController 노출
    func showFileDownloadViewController(_ contentUrl : URL) {
        DispatchQueue.main.async {
            let downloadView = UIActivityViewController(activityItems: [contentUrl], applicationActivities: nil)
            downloadView.excludedActivityTypes = [.addToReadingList, .airDrop, .assignToContact, .copyToPasteboard, .mail, .message, .openInIBooks, .postToFacebook, .postToFlickr, .postToTencentWeibo, .postToTwitter, .postToVimeo, .postToWeibo, .print , .saveToCameraRoll]
            
            if #available(iOS 11.0, *) {
                downloadView.excludedActivityTypes?.append(.markupAsPDF)
            }

            self.present( downloadView, animated: true, completion: nil )
        }
    }
    
    // 더보기 메뉴 클릭 리스너
    func onMenuBottomSheetClick(_ selected: String) {
        switch selected {
        // 쿠키
        case DefineCode.MORE_MENU_COOKIE:
            moveCookie()
            
        // 프린트
        case DefineCode.MORE_MENU_PRINT:
            onPrint()
            
        // 데스크탑<->모바일 모드
        case DefineCode.MORE_MENU_STORAGE:
            moveStorage()
            
        // 방문기록
        case DefineCode.MORE_MENU_HISTORY:
            moveHistory()
            
        // 콘솔로그
        case DefineCode.MORE_MENU_CONSOLE_LOG:
            moveConsoleLog()
            
        // 웹킷로그
        case DefineCode.MORE_MENU_WEBKIT_LOG:
            moveWebkitLog()
            
        // 자바스크립트 실행
        case DefineCode.MORE_MENU_EXE:
            onJavascriptExecute()
            
        // 웹HTML 소스보기
        case DefineCode.MORE_MENU_HTML_ELEMENT:
            onHtmlElement()
            
        // 설정
        case DefineCode.MORE_MENU_SETTING:
            moveSetting()
            
        default: break
            
        }
    }
    
    // 쿠키 페이지로 이동
    func moveCookie() {
        let controller = self.controller(type: CookieViewController.self, name: "Cookie", id: "cookie", bundle: nil)
        controller?.url = wv_main?.url?.absoluteString
        self.present(controller)
    }
    
    // 프린트
    func onPrint() {
        let printInfo : UIPrintInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = wv_main?.title ?? "웹 브라우저"
        printInfo.orientation = .portrait
        printInfo.outputType = .general
        printInfo.duplex = .none
        
        let printController = UIPrintInteractionController()
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = true  // 복사본을 여러개만들수 있음
        printController.showsPaperSelectionForLoadedPapers = true   // 페이지 범위 지정 가능
        printController.printFormatter = wv_main?.viewPrintFormatter()
        printController.printingItem = wv_main?.url
        
        printController.present(animated: true, completionHandler: { controller , isCompleted , error in
            if( !isCompleted && error != nil ) {
                Log.p("print failed = \(error?.localizedDescription ?? "")")
            }
        })
    }
    
    // 데스크탑<->모바일 모드 변경
    func onPcMobileMode() {
        guard (wv_main != nil) else {
            return
        }
        
        guard var url = wv_main.url?.absoluteString else {
            return
        }
        
        appDelegate.isMobile = !appDelegate.isMobile
        
        // 커스텀 user-agent
        if( appDelegate.isMobile ) {
            wv_main.customUserAgent = ""
            wv_main.reload()
        }
        else {
            wv_main.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS) AppleWebKit (KHTML, like Gecko) Safari"
                        
            url = url.replacingOccurrences(of: "^https://m.", with: "https://www.", options: .regularExpression, range: nil)
                     .replacingOccurrences(of: "^http://m.", with: "http://www.", options: .regularExpression, range: nil)
            
            loadUrl(_url: url)
        }
        Log.p("customUserAgent \(wv_main.customUserAgent ?? "")")
    }
    
    // 방문기록 페이지로 이동
    func moveHistory() {
        let controller = self.controller(type: HistoryViewController.self, name: "History", id: "history", bundle: nil)
        controller?.delegate = self
        self.present(controller)
    }
    
    // 콘솔로그 페이지로 이동
    func moveConsoleLog() {
        let controller = self.controller(type: ConsoleLogViewController.self, name: "ConsoleLog", id: "consoleLog", bundle: nil)
        controller?.consoleLogList = consoleLogList
        self.present(controller)
    }
    
    // 웹킷로그 페이지로 이동
    func moveWebkitLog() {
        let controller : WebkitLogViewController? = controller(type: WebkitLogViewController.self, name: "WebkitLog", id: "WebkitLog", bundle: nil)
        present(controller)
    }
    
    // 자바스크립트 실행
    func onJavascriptExecute() {
        let storyboard : UIStoryboard = UIStoryboard(name: "ScriptInputDialog", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "ScriptInputDialog" ) as? ScriptInputDialogController else
        {
            return
        }

        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext // 컨텐츠가 다른 뷰 컨트롤러의 컨텐츠 위에 표시
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: false, completion: nil)
    }
    
    // 스크립트 실행
    func onScriptInputExecute(script: String) {
        jsBridge.evaluateJavascript(controller: self, webView: wv_main, script: script) { (result: Any?) in
            if let result = result {
                let message = String(describing: result)
                _ = Util.showAlertDialog(controller: self, title: "자바스크립트 실행 결과", message: message, action1: nil, action2: nil)
            }
        }
    }
    
    // 웹HTML 소스보기
    func onHtmlElement() {
        let script = "document.documentElement.outerHTML;"
        jsBridge.evaluateJavascript(controller: self, webView: wv_main, script: script) { (result: Any?) in
            var source : String = ""
            if let result = result {
                source = String(describing: result)
            }
            
            let controller : HtmlElementViewController? = self.controller(type: HtmlElementViewController.self, name: "HtmlElement", id: "htmlElement", bundle: nil)
            controller?.element = source
            self.present(controller)
        }
    }
    
    // Storage 메뉴
    func moveStorage() {
        self.wv_main.evaluateJavaScript("javascript:JSON.stringify(localStorage);") { (any1: Any?, error: Error?) in
            let local : String = (any1 as? String) ?? ""
            
            self.wv_main.evaluateJavaScript("javascript:JSON.stringify(sessionStorage);") { (any2: Any?, error: Error?) in
                let session : String = (any2 as? String) ?? ""

                let controller = self.controller(type: StorageViewController.self, name: "Storage", id: "storage", bundle: nil)
                controller?.localStorage = local
                controller?.sessionStorage = session
                self.present(controller)
            }
        }
    }
    
    // 설정메뉴
    func moveSetting() {
        let controller = self.controller(type: SettingViewController.self, name: "Setting", id: "setting", bundle: nil)
        controller?.userAgent = (wv_main.value(forKey: "userAgent") as? String) ?? ""
        controller?.baseProtocol = self
        self.present(controller)
    }
    
    // 앱 -> 웹에 메시지 전달
    func onWebMessage() {
        let dto = JsGetMessageData.init(title: "알림", message: "App에서 전달한 메시지 !!!!!")
        let jsonString = Util.dtoToJsonString(dto: dto)
        
        jsBridge.callJsFunction(webView: wv_main, funcName: "appGetMessage", [jsonString] )
    }
    
    // 앱 -> 웹에 메시지 전달 후 리턴값 받음
    func onWebMessageReturn() {
        let dto = JsGetMessageData.init(title: "알림", message: "App에서 전달한 메시지 !!!!!")
        let jsonString = Util.dtoToJsonString(dto: dto)
        
        jsBridge.callJsFunction(webView: wv_main, funcName: "appGetMessageReturn", [jsonString] ) {
            (result, error) in
            // start 웹킷로그
            let _param = "반환값 : \(String(describing: result ?? ""))\n에러 : \(error?.localizedDescription ?? "")"
            SQLiteService.insertWebkitLogData(.NATIVE_TO_JS_RETURN, _param)
            // end 웹킷로그
            
            if result is String {
                _ = Util.showAlertDialog(controller: self, title: "", message: result as! String, action1: nil, action2: nil)
            }
        }
    }
    
    // 컨트롤러 dismiss 후 콜백
    func onDismiss(vc: BaseViewController, data: [String : Any]) {
        if(vc is SettingViewController) {
            let isChanged : Bool = (data["isChanged"] as? Bool) ?? false
            if(isChanged) {
                onPcMobileMode()
            }
        }
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
        START_TIME = Date().timeIntervalSince1970
        
        consoleLogList.removeAll()
        
        // start 웹킷로그
        let url = "\(webView.url?.absoluteString ?? "")"
        MainViewController.WEBVIEW_LOAD_URL = url
        MainViewController.WEBVIEW_LOAD_TIME = Util.dateToString(date: Date(), format: "yyyyMMddHHmmss")
        SQLiteService.insertWebkitLogData(.WEBVIEW_START, url, MainViewController.WEBVIEW_LOAD_TIME)
        // end 웹킷로그
            
        // 프로그레스바 표시
        showWebViewLoadingBar( isShow: true, _progress: 0 )
        
        // 타이틀에 url 표시
        lbWebTitle.text = url
        editUrl.text = url
    }

    // 웹 리다이렉션
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        // start 웹킷로그
        let _param = "\(lbWebTitle.text ?? "")\n->\n\(webView.url?.absoluteString ?? "")"
        SQLiteService.insertWebkitLogData(.WEBVIEW_REDIRECT, _param)
        // end 웹킷로그
        
        // 타이틀에 url 표시
        let url : String? = webView.url?.absoluteString
        lbWebTitle.text = url
        editUrl.text = url
        
        changePageMoveButton()
    }
    
    // 웹뷰에서 컨텐츠를 받기 시작
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // 웹 로드 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let loadTime : Double = round((Date().timeIntervalSince1970-START_TIME)*1000)/1000
        
        // start 웹킷로그
        let _param = "\(loadTime)초"
        SQLiteService.insertWebkitLogData(.WEBVIEW_FINISH, _param)
        // end 웹킷로그
                
        // 프로그레스바 숨김
        showWebViewLoadingBar( isShow: false, _progress: 0 )
        
        // 타이틀에 url 표시
        let url : String? = webView.url?.absoluteString
        lbWebTitle.setTextWithIcon(_text: Util.getUrlDomain(_url: url), _icon: "ic_lock")
        editUrl.text = url
        
        changePageMoveButton()
        
        if let item = wv_main.backForwardList.currentItem {
            // 방문한페이지 저장
            let date : String = Util.dateToString(date: Date(), format: "yyyyMMddHHmmss")
            let param : [String] = [date, item.title ?? "", item.url.absoluteString]
            historyList = SQLiteService.insertHistoryData(param:param)

            // 즐겨찾기 여부
            chkBookmark.isChecked = SQLiteService.selectBookmarkCntByURL(url: item.url.absoluteString)
        }
    }

    // 웹컨텐츠 프로세스 종료
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {

    }
    
//    // 웹 탐색중 에러
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//
//    }
    
    // 웹컨텐츠 로드중 에러
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let err = error as NSError
        
        // start 웹킷로그
        let _param = "\(err.code)\n\(err.localizedDescription)"
        SQLiteService.insertWebkitLogData(.WEBVIEW_ERROR, _param)
        // end 웹킷로그

        switch err.code {
        case NSURLErrorTimedOut, NSURLErrorCannotConnectToHost, NSURLErrorNotConnectedToInternet, NSURLErrorSecureConnectionFailed, -999, -1003 :
//            wv_main?.stopLoading()
            
            let message = "에러가 발생하였습니다. ([\(err.code)] \(err.localizedDescription))"
            let parameter = Util.makeQueryParameter(params: ["errorMsg":message])
            
            let storyboard : UIStoryboard = UIStoryboard(name: "ErrorDialog", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "ErrorDialog" ) as? ErrorDialogController {
                controller.modalPresentationStyle = .overCurrentContext // 컨텐츠가 다른 뷰 컨트롤러의 컨텐츠 위에 표시
                controller.errorMsg = parameter

                self.present(controller, animated: false, completion: nil)
            }

            showWebViewLoadingBar( isShow: false, _progress: 0 )
            changePageMoveButton()
            break
            
        default:
            return
        }
    }

    
    func webView(_ webView: WKWebView, authenticationChallenge  : URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> Void) {
        
    }

    // SSL 인증요청에 대한 응답
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let serverTrust : SecTrust = challenge.protectionSpace.serverTrust {
            var error : CFError? = nil
            if #available(iOS 12.0, *) {
                if( !SecTrustEvaluateWithError(serverTrust, &error) ) {
                    // start 웹킷로그
                    let _param = "\(error?.localizedDescription)"
                    SQLiteService.insertWebkitLogData(.WEBVIEW_SSL, _param)
                    // end 웹킷로그
                    
                    completionHandler(.cancelAuthenticationChallenge, nil)
                }
                else {
                    let credential = URLCredential(trust: serverTrust)
                    completionHandler(.useCredential, credential)
                }
            }
        }
    }
        
    // URL이 로드 될때 웹탐색을 허용할지 취소할지 결정 (목적지는 알고 있지만 아직 이동은 하지 않은 상태에서 이동 허가제어 가능)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request : URLRequest = navigationAction.request

        guard let url: URL = request.url else {
            return
        }

        if( checkRedirectUrl(url: url) ) {
            // start 웹킷로그
            let _param = "\(url.absoluteString)"
            SQLiteService.insertWebkitLogData(.WEBVIEW_DECIDE_ACTION1, _param)
            // end 웹킷로그
            
            decisionHandler(.cancel)
        }
        else {
            decisionHandler(.allow)
        }
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        let request : URLRequest = navigationAction.request
        
        // 모바일/PC 모드 설정
        if( appDelegate.isMobile ) {
            preferences.preferredContentMode = .mobile
        }
        else {
            preferences.preferredContentMode = .desktop
        }
        
        guard let url: URL = request.url else {
            return
        }
        
        if( checkRedirectUrl(url: url) ) {
            // start 웹킷로그
            let _param = "\(url.absoluteString)"
            SQLiteService.insertWebkitLogData(.WEBVIEW_DECIDE_ACTION2, _param)
            // end 웹킷로그
            
            decisionHandler(.cancel, preferences)
        }
        else {
            decisionHandler(.allow, preferences)
        }
    }
    
    func checkRedirectUrl( url : URL) -> Bool {
        var ext : String = url.pathExtension.lowercased()
        if(ext.isEmpty) {
            if let index = url.absoluteString.lastIndex(of: ".") {
                ext = String(url.absoluteString[url.absoluteString.index(index, offsetBy: 1)...])
            }
        }
        
        // 파일 다운로드
        let downloadType = checkDownloadUrl(ext: ext, mimeType: "")
        if( downloadType != DefineCode.URL_DOWNLOAD_NONE ) {
            showDownloadConfirmDialog(downloadType: downloadType, url: url)
            
            self.showWebViewLoadingBar(isShow: false, _progress: 0)
            return true;
        }
        
        let strUrl = url.absoluteString
        
        // 앱스토어 이동
        if( strUrl.starts(with: "itms-appss://") || strUrl.starts(with: "itms://") ) {
            if( UIApplication.shared.canOpenURL(url) ) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                self.showWebViewLoadingBar(isShow: false, _progress: 0)
                return true
            }
        }
        
        // 앱스토어 이동
        if( strUrl.starts(with: "https://itunes.apple.com/kr/app/") || strUrl.starts(with: "http://itunes.apple.com/kr/app/") ) {
            if( UIApplication.shared.canOpenURL(url) ) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                self.showWebViewLoadingBar(isShow: false, _progress: 0)
                return true
            }
        }
        
        // sms: tel:
        if( ["sms" , "tel"].contains( url.scheme ) ) {
            if( UIApplication.shared.canOpenURL(url) ) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                self.showWebViewLoadingBar(isShow: false, _progress: 0)
                return true
            }
        }
        
        return false
    }

    
    // 응답이 완료된후 웹탐색을 허용할지 취소할지 결정
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let response = navigationResponse.response
                
        guard let url: URL = response.url else {
            decisionHandler(.cancel)
            return
        }
        
        let mimeType : String = (response.mimeType ?? "").lowercased()
        var ext : String = url.pathExtension.lowercased()
        if(ext.isEmpty) {
            if let index = url.absoluteString.lastIndex(of: ".") {
                ext = String(url.absoluteString[url.absoluteString.index(index, offsetBy: 1)...])
            }
        }
        
        // 파일 다운로드
        let downloadType = checkDownloadUrl(ext: ext, mimeType: mimeType)
        if( downloadType != DefineCode.URL_DOWNLOAD_NONE ) {
            // start 웹킷로그
            let _param = "\(url.absoluteString)\nMIME : \(response.mimeType ?? "")"
            SQLiteService.insertWebkitLogData(.WEBVIEW_DECIDE_ACTION2, _param)
            // end 웹킷로그
            
            self.showDownloadConfirmDialog(downloadType: downloadType, url: url)
            self.showWebViewLoadingBar(isShow: false, _progress: 0)
            decisionHandler(.cancel)
            return;
        }

        decisionHandler(.allow)
    }
    
    // URL 타입 구하기
    func checkDownloadUrl( ext: String , mimeType: String ) -> Int {
        var type = DefineCode.URL_DOWNLOAD_NONE
        
        let imageArr = ["png", "jpg", "jpeg", "image/png", "image/jpg", "image/jpeg"]
        let fileArr = ["pdf", "zip", "application/pdf", "application/zip"]
        // 이미지 확인
        if( imageArr.contains( ext ) || imageArr.contains( mimeType ) ) {
            type = DefineCode.URL_DOWNLOAD_IMG
        }
        // 파일 확인
        else if( fileArr.contains( ext ) || fileArr.contains( mimeType ) ) {
            type = DefineCode.URL_DOWNLOAD_FILE
        }
        
        return type
    }
    
    // 다운로드 확인 다이얼로그
    func showDownloadConfirmDialog( downloadType : Int , url : URL ) {
        let action1 = UIAlertAction(title: "취소", style: .cancel)
        let action2 = UIAlertAction(title: "확인", style: .default) { (action: UIAlertAction) in
            self.wkWebViewFileDownload(type: downloadType, url: url)
        }
        _ = Util.showAlertDialog(controller: self, title: "", message: "파일을 다운로드 하시겠습니까?", action1: action1, action2: action2)
    }
}

// 웹 -> 네이티비 호출 콜백 프로토콜
extension MainViewController : JsBridgeProtocol {
    
    func jsBridgeCallback(requestId: Int, params: String) {
        switch requestId {
        case DefineCode.JS_ALERT_POPUP:
            onJsAlertPopup( params: params )
            
        case DefineCode.JS_CONSOLE_LOG:
            onJsConsoleLog( params: params )
        default: break
            
        }
    }
    
    // 얼럿팝업
    func onJsAlertPopup( params : String ) {
        guard let dto = Util.jsonStringToDto(type: JsAlertPopupData.self, params: params) else {
            return
        }

        _ = Util.showAlertDialog(controller: self, title: dto.title, message: dto.message, action1: nil, action2: nil)
    }
    
    // 콘솔로그
    func onJsConsoleLog( params : String ) {
        let date : String = Util.dateToString(date: Date(), format: "yyyyMMddHHmmss")
        let log : String = params
        let data : ConsoleLogData = ConsoleLogData(date: date, log: log)
        consoleLogList.append(data)
    }
}

// 히스토리, 즐겨찾기 -> 메인 프로토콜
extension MainViewController : URLItemProtocol {
    func onDismissViewController(controller: UIViewController) {
        // 즐겨찾기 여부 확인
        if( controller is BookmarkViewController ) {
            setBookmarkList()
            if let item = wv_main.backForwardList.currentItem {
                chkBookmark.isChecked = SQLiteService.selectBookmarkCntByURL(url: item.url.absoluteString)
            }
        }
    }
    
    func onUrlClick(url: String) {
        loadUrl(_url: url)
    }
}

// 웹킷 스크롤시 타이틀바 바텀바 show/hide
extension MainViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(!isEditMode) {
            let y = scrollView.panGestureRecognizer.translation(in: scrollView.superview).y
            if(y > 0) {
                // Up
                if(y != yPosition) {
                    self.conUrlBarHeight.constant = 56
                    self.conBottomMenuHeight.constant = 48
                }
            }
            else {
                // Down
                if(y != yPosition) {
                    self.conUrlBarHeight.constant = 0
                    self.conBottomMenuHeight.constant = 0
                }
            }
            yPosition = y;
        }
    }
}

// URL 타이틀바 즐겨찾기/최근 목록
extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        sectionView.backgroundColor = BRColor.colorByString(rgb: "#F2F2F2")
        let titleLabel = UILabel()
        titleLabel.frame = CGRect.init(x: 8, y: 0, width: sectionView.frame.width-16, height: 40)
        titleLabel.text = isBookmarkMode ? "즐겨찾기" : "히스토리"
        titleLabel.sizeToFit()
        titleLabel.font = .boldSystemFont(ofSize: 15)
        sectionView.addSubview(titleLabel)
        titleLabel.center.y = sectionView.center.y
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isBookmarkMode ? bookmarkList.count : historySearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "siteCell") as? SiteTableCell else {
            return UITableViewCell()
        }
        
        if isBookmarkMode {
            cell.lbTitle.text = bookmarkList[indexPath.row].title
            cell.lbUrl.text = bookmarkList[indexPath.row].url
            cell.divider.isHidden = (bookmarkList.count-1 == indexPath.row) ? true : false
        }
        else {
            cell.lbTitle.text = historySearchList[indexPath.row].title
            cell.lbUrl.text = historySearchList[indexPath.row].url
            cell.divider.isHidden = (historySearchList.count-1 == indexPath.row) ? true : false
        }
        
        return cell
    }
    
    // 테이블셀 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = isBookmarkMode ? bookmarkList[indexPath.row].url : historySearchList[indexPath.row].url
        
        loadUrl(_url: url)
        changeToEditMode(isEdit: false)
    }
}

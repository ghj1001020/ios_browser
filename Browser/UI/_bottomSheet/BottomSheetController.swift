//
//  BottomSheetController.swift
//  ios_lottostat
//
//  Created by 권혁준 on 2021/11/14.
//

import UIKit


class BottomSheetController: UIViewController {

    private let contentController : UIViewController
    
    // 딤영역 클릭시 취소 여부
    var isCancelable = true
    
    
    init(contentController: UIViewController) {
        self.contentController = contentController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.contentController = UIViewController()
        super.init(coder: coder)
    }
    

    // 바텀시트의 상태
    enum BottomSheetState {
        case expanded
        case normal
    }

    
    // 바텀시트와 Safe Area Top 사이의 최소 간격
    let bottomSheetPanMinTopConstant : CGFloat = 56.0
    // 바텀시트와 Safe Area Top 사이의 간격
    lazy var bottomSheetPanCurrentTopConstant : CGFloat = bottomSheetPanMinTopConstant
    

    
    private let dim : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()
    
    private let indicator : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()
        
    private let bottomSheet : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        if #available(iOS 11.0, *) {
            view.layer.cornerRadius = 28
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 28, height: 28))
            let shapeLayer = CAShapeLayer()
            shapeLayer.frame = view.bounds
            shapeLayer.path = path.cgPath
            view.layer.mask = shapeLayer
        }
        view.clipsToBounds = true
        
        return view
    }()
    
    // 바텀시트 상단높이 제약
    private var bottomSheetTopConstraint : NSLayoutConstraint!
    
    // 바텀시트 높이
    private var defaultHeight : CGFloat = 300
    

    // 뷰가 로드된 후 한번호출
    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
        
        
        // 키보드 show/hide 옵저버
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 보이면 뷰 올리기
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo else {
            self.view.frame.origin.y = -200
            return
        }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            self.view.frame.origin.y = -200
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        self.view.frame.origin.y = -keyboardHeight
    }
    
    // 키보드 숨기면 뷰 내리기
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    

    // 로드된 뷰가 화면에 표시될때 마다 호출
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    func initLayout() {
        self.view.addSubview(dim)
        self.view.addSubview(indicator)
        self.view.addSubview(bottomSheet)
        
        // 딤영역
        dim.translatesAutoresizingMaskIntoConstraints = false // 자동레이아웃을 사용하여 뷰의크기와 위치를 동적으로 계산
        dim.alpha = 0.0
        NSLayoutConstraint.activate([
            dim.topAnchor.constraint(equalTo: self.view.topAnchor) ,
            dim.leadingAnchor.constraint(equalTo: self.view.leadingAnchor) ,
            dim.trailingAnchor.constraint(equalTo: self.view.trailingAnchor) ,
            dim.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        let dimTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(gestureDimTapped(_:)) )
        if isCancelable {
            dim.addGestureRecognizer(dimTapRecognizer)
            dim.isUserInteractionEnabled = true
        }

        
        // 바텀시트 영역
        bottomSheet.translatesAutoresizingMaskIntoConstraints = false
        var topHeight : CGFloat = self.view.frame.height;
        if #available(iOS 11.0, *) {
            topHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height
        }
        bottomSheetTopConstraint = bottomSheet.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topHeight)
        NSLayoutConstraint.activate([
            bottomSheetTopConstraint ,
            bottomSheet.leadingAnchor.constraint(equalTo: self.view.leadingAnchor) ,
            bottomSheet.trailingAnchor.constraint(equalTo: self.view.trailingAnchor) ,
            bottomSheet.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        // 바텀시트 드래그 제스처
        let viewPanRecognizer = UIPanGestureRecognizer(target: self, action: #selector(gestureViewPanned(_:)) )
        // 드래그 제스처의 딜레이 없앰
        viewPanRecognizer.delaysTouchesBegan = false
        viewPanRecognizer.delaysTouchesEnded = false
        self.view.addGestureRecognizer(viewPanRecognizer)
        
        // 인디케이터 영역
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: 55) ,
            indicator.heightAnchor.constraint(equalToConstant: 8) ,
            indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor) ,
            indicator.bottomAnchor.constraint(equalTo: self.bottomSheet.topAnchor, constant: -6)
        ])
    
        // 컨텐츠
        self.addChild(contentController)
        bottomSheet.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        bottomSheet.clipsToBounds = true
//        contentController.bottomSheet = self
        contentController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentController.view.topAnchor.constraint(equalTo: bottomSheet.topAnchor) ,
            contentController.view.bottomAnchor.constraint(equalTo: bottomSheet.bottomAnchor) ,
            contentController.view.leadingAnchor.constraint(equalTo: bottomSheet.leadingAnchor) ,
            contentController.view.trailingAnchor.constraint(equalTo: bottomSheet.trailingAnchor)
        ])
    }
    
    // 바텀시트 열기 애니메이션
    func showBottomSheet(state: BottomSheetState = .normal) {
        if( state == .normal ) {
            var topHeight = self.view.frame.height - defaultHeight
            if #available(iOS 11.0, *) {
                topHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height - defaultHeight
            }
            bottomSheetTopConstraint.constant = topHeight
        }
        else {
            bottomSheetTopConstraint.constant = bottomSheetPanMinTopConstant
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.dim.alpha = self.getDimAlphaByBottomSheetTopConstant(constant: self.bottomSheetTopConstraint.constant)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func gestureDimTapped(_ recognizer: UITapGestureRecognizer) {
        hideBottomSheet()
    }
    
    // 바텀시트 닫기 애니메이션
    func hideBottomSheet() {
        var topHeight = self.view.frame.height
        if #available(iOS 11.0, *) {
            topHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height
        }
        bottomSheetTopConstraint.constant = topHeight
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
            self.dim.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { (isComplete : Bool) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func gestureViewPanned(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        switch recognizer.state {
        case .began:
            bottomSheetPanCurrentTopConstant = bottomSheetTopConstraint.constant
            
        case .changed:
            if bottomSheetPanCurrentTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetTopConstraint.constant = bottomSheetPanCurrentTopConstant + translation.y
            }
            dim.alpha = getDimAlphaByBottomSheetTopConstant(constant: bottomSheetTopConstraint.constant)
            
        case .ended:
            // 빠르게 아래로 드래그하면 닫힘
            if velocity.y > 1500 {
                hideBottomSheet()
                return
            }
            
            var viewHeight = self.view.frame.height
            if #available(iOS 11.0, *) {
                viewHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height
            }
            let arrValues : [CGFloat] = [bottomSheetPanMinTopConstant, viewHeight-defaultHeight, viewHeight]
            let nearest = getNearestNumber(number: bottomSheetTopConstraint.constant, values: arrValues)

            // expanded
            if nearest == bottomSheetPanMinTopConstant {
                showBottomSheet(state: .expanded)
            }
            // normal
            else if nearest == viewHeight-defaultHeight {
                showBottomSheet(state: .normal)
            }
            // dismiss
            else {
                hideBottomSheet()
            }
            
            bottomSheetPanCurrentTopConstant = bottomSheetTopConstraint.constant
            
        default:
            break
        }
    }
    
    // 주어진 값과 가장가까운 배열의 값 반환
    func getNearestNumber(number: CGFloat, values: [CGFloat]) -> CGFloat {
        let nearest = values.min { num1, num2 in
            abs(number-num1) < abs(number-num2)
        }
        
        return nearest ?? number
    }
    
    // bottom sheet 의 top constant 값으로 dim alpha 계산
    func getDimAlphaByBottomSheetTopConstant( constant: CGFloat ) -> CGFloat {
        let alpha : CGFloat = 0.7
        
        var viewHeight = self.view.frame.height
        if #available(iOS 11.0, *) {
            viewHeight = self.view.safeAreaInsets.bottom + self.view.safeAreaLayoutGuide.layoutFrame.height
        }
        
        // dim 알파 0.7 위치
        let fullDimPosition = (viewHeight-defaultHeight)/2
        if( constant < fullDimPosition ) {
            return alpha
        }
        
        // dim 알파 0 위치
        let noDimPosition = viewHeight
        if( constant >= noDimPosition ) {
            return 0.0
        }
        
        // 높이에 따라 알파값 계산
        return alpha * (1 - (constant-fullDimPosition)/(noDimPosition-fullDimPosition))
    }
    
}

//
//  BottomSheetViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

protocol BottomSheetDelegate: AnyObject {
    func didSelectDate(date: Date)
}

final class DatePickerBottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: BottomSheetDelegate?
    
    // TODO: - height 기기대응되게 변경
    
    let bottomHeight: CGFloat = 340
    
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - UI Properties
    
    // 기존 화면을 흐려지게 만들기 위한 뷰
    private let dimmedBackView: UIView = {
        let view = UIView()
        view.alpha = 0.7
        view.layer.backgroundColor = UIColor.black000.cgColor
        return view
    }()
    
    // 바텀 시트 뷰
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white000
        view.roundCorners(cornerRadius: 6, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        return view
    }()
    
    private let datePickerView = DatePickerView()
    
    // dismiss Indicator View UI 구성 부분
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let confirmButton = DOOButton(type: .enabled, title: "확인")
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierachy()
        setLayout()
        setGestureRecognizer()
        setAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }
    
    // MARK: - @objc Methods

    /// UITapGestureRecognizer 연결 메서드
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    @objc private func confirmButtonTapped() {
        hideBottomSheetAndGoBack()
    }
    
    /// UISwipeGestureRecognizer 연결 메서드
    @objc private func panGesture(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.state == .ended {
            switch recognizer.direction {
            case .down:
                hideBottomSheetAndGoBack()
            default:
                break
            }
        }
    }
    
    @objc private func confirmButtonTapped(_ sender: UIButton) {
        delegate?.didSelectDate(date: datePickerView.datePicker.date)
        hideBottomSheetAndGoBack()
    }
}

// MARK: - Private Extension

private extension DatePickerBottomSheetViewController {
    
    func setStyle() {
        view.backgroundColor = .clear
        
        dimmedBackView.alpha = 0.0
    }
    
    func setHierachy() {
        view.addSubviews(dimmedBackView,
                         bottomSheetView,
                         datePickerView,
                         dismissIndicatorView,
                         confirmButton)
    }
    
    func setGestureRecognizer() {
        /// 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        /// 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(panGesture))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    // 레이아웃 세팅
    func setLayout() {
        dimmedBackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }

        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint
        ])
        
        dismissIndicatorView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(12)
            $0.centerX.equalTo(bottomSheetView)
            $0.height.equalTo(5)
            $0.width.equalTo(35)
        }
        
        datePickerView.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(10)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setAddTarget() {
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
    }
    
    /// 바텀 시트 표출 애니메이션 메서드
    func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    /// 바텀 시트 사라지는 애니메이션 메서드
    func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

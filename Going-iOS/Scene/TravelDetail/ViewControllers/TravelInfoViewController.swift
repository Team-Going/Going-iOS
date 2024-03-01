//
//  TravelInfoViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/2/24.
//

import UIKit

import SnapKit

final class TravelInfoViewController: UIViewController {

    // MARK: - UI Properites
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("여행 정보"))
    
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private lazy var travelNameView: TravelNameView = {
        let view = TravelNameView()
        view.travelNameTextField.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var travelDateView = TravelDateView()
    
    private let buttonHorizStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 7
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var quitTravelButton: DOOButton = {
        let btn = DOOButton(type: .white, title: "나가기")
        btn.addTarget(self, action: #selector(quitTravelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var editTravelButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "수정하기")
        btn.addTarget(self, action: #selector(editTravelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
    }
}

// MARK: - Private Methods

private extension TravelInfoViewController {
    func setStyle() {
        self.view.backgroundColor = UIColor(resource: .white000)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         navigationUnderlineView,
                         travelNameView,
                         travelDateView,
                         buttonHorizStackView)
        
        buttonHorizStackView.addArrangedSubviews(quitTravelButton, editTravelButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderlineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        travelNameView.snp.makeConstraints {
            $0.top.equalTo(navigationUnderlineView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(101))
        }
        
        travelDateView.snp.makeConstraints {
            $0.top.equalTo(travelNameView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(79))
        }
        
        buttonHorizStackView.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
        }
        
        quitTravelButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(160))
        }
        
        editTravelButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(160))
        }
    }
    
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - @objc Methods
    
    @objc
    func quitTravelButtonTapped() {
        print("button tapped")
    }
    
    @objc
    func editTravelButtonTapped() {
        print("button tapped")
    }
}

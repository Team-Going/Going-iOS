//
//  JoinTravelViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class JoinTravelViewController: UIViewController {
    
    // MARK: - Size
    
    let absoluteWidth = UIScreen.main.bounds.width
    let absoluteHeight = UIScreen.main.bounds.height
    
    // MARK: - UI Properties
    
    // TODO: - Dummy Data 생성
    
    private let navigationBar: NavigationView = {
        let nav = NavigationView()
        nav.titleLabel.text = "여행 입장하기"
        return nav
    }()
    
    private let codeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.JoinTravel.inviteCodeTitle
        label.font = .pretendard(.body2_bold)
        label.textColor = .gray700
        return label
    }()
    
    private let codeTextField: UITextField = {
        let field = UITextField()
        field.setLeftPadding(amount: 12)
        field.font = .pretendard(.body3_medi)
        field.setTextField(forPlaceholder: StringLiterals.JoinTravel.placeHolder, forBorderColor: .gray200, forCornerRadius: 6)
        field.keyboardType = .numberPad
        return field
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/6"
        label.font = .pretendard(.detail2_regular)
        label.textColor = .gray200
        return label
    }()
    
    private lazy var nextButton: DOOButton = {
        let btn = DOOButton(type: .unabled, title: "다음")
        btn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierachy()
        setLayout()
        setDelegate()
        setNotification()
    }

// MARK: - Private Extension

private extension JoinTravelViewController {
    func setStyle() {
        view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierachy() {
        view.addSubviews(navigationBar,
                         codeTitleLabel,
                         codeTextField,
                         characterCountLabel,
                         nextButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(absoluteHeight / 812 * 50)
        }
        
        codeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        codeTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(codeTitleLabel.snp.bottom).offset(8)
            $0.width.equalTo(absoluteWidth / 375 * 327)
            $0.height.equalTo(absoluteHeight / 812 * 48)
        }
        
        characterCountLabel.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(codeTextField.snp.trailing).offset(4)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(absoluteHeight / 812 * 50)
            $0.width.equalTo(absoluteWidth / 375 * 327)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    

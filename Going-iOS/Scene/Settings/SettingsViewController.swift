//
//  SettingsViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/8/24.
//

import UIKit

import SnapKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - UI Properties
    
    private let navigationBar: NavigationView = {
        let nav = NavigationView()
        nav.titleLabel.text = "설정"
        return nav
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var myProfileButton = { setButton(forText: "내 프로필", forImage: ImageLiterals.OurToDo.btnEnter) }()
    private lazy var askButton = { setButton(forText: "문의", forImage: ImageLiterals.OurToDo.btnEnter) }()
    
    private lazy var serviceVersionButton = { setButton(forText: "서비스버전")}()
    private let serviceVersionInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "v1.0"
        label.font = .pretendard(.detail1_regular)
        label.textColor = .gray300
        return label
    }()
    
    private lazy var termsConditionButton = { setButton(forText: "약관 및 정책", forImage: ImageLiterals.OurToDo.btnEnter) }()
    private lazy var aboutButton = { setButton(forText: "About doorip", forImage: ImageLiterals.OurToDo.btnEnter) }()
    private lazy var logOutButton = { setButton(forColor: .red500, forText: "로그아웃") }()
    
    private let resignButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원탈퇴", for: .normal)
        btn.titleLabel?.textColor = .gray300
        btn.setImage(ImageLiterals.Settings.btnResign, for: .normal)
        btn.setUnderline()
        return btn
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setHierarchy()
        setLayout()
    }
}

private extension SettingsViewController {
    func setStyle() {
        self.view.backgroundColor = .gray50
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        self.view.addSubviews(navigationBar, buttonStackView, resignButton)
        buttonStackView.addArrangedSubviews(myProfileButton,
                                            askButton,
                                            serviceVersionButton,
                                            termsConditionButton,
                                            aboutButton,
                                            logOutButton)
        serviceVersionButton.addSubview(serviceVersionInfoLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(ScreenUtils.getHeight(68))
            $0.width.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        serviceVersionInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(serviceVersionButton)
            $0.leading.equalToSuperview().inset(16)
        }
        
        resignButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
        }
    }
    
    func setButton(forColor: UIColor? = .gray700, forText: String, forImage: UIImage? = nil) -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = .pretendard(.body1_medi)
        btn.backgroundColor = .white000
        btn.layer.cornerRadius = 6
        btn.clipsToBounds = true
        btn.setTitleColor(forColor, for: .normal)
        btn.setTitle(forText, for: .normal)
        btn.titleLabel?.textAlignment = .left
        btn.setImage(forImage, for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        
        btn.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        return btn
    }
    
    func setBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white000
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }
    
    func setTitleLabel(forColor: UIColor? = .gray700, forText: String) -> UILabel {
        let label = UILabel()
        label.font = .pretendard(.body1_medi)
        label.textColor = forColor
        label.text = forText
        return label
    }
    
    func setIcon(forImage: UIImage? = nil) -> UIImageView {
        let icon = UIImageView()
        icon.image = forImage
        return icon
    }
}

//
//  DOONavigationBar.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/9/24.
//

import UIKit

import SnapKit

protocol DOONavigationBarDelegate: AnyObject {
    func saveTextButtonTapped()
    func pushToTravelInfoVC()
}

final class DOONavigationBar: UIView {
    
    enum NavigationBarType {
        case backButtonOnly
        case ourToDo
        case myToDo
        case titleLabelOnly(String)
        case backButtonWithTitle(String)
        case testResult(String)
        case rightItemWithTitle(String)
    }
    
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .btnBack), for: .normal)
        btn.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .btnSave), for: .normal)
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body1_bold)
        label.textColor = UIColor(resource: .gray700)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .btnProfile), for: .normal)
        btn.addTarget(self, action: #selector(pushToMyProfileVC), for: .touchUpInside)
        return btn
    }()
    
    lazy var saveTextButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(StringLiterals.ToDo.save, for: .normal)
        btn.setTitleColor(UIColor(resource: .gray200), for: .normal)
        btn.titleLabel?.font = .pretendard(.body2_bold)
        btn.isEnabled = false
        btn.addTarget(self, action: #selector(saveTitleButtonTapped), for: .touchUpInside)
        return btn
    }()
  
    private lazy var travelInfoButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .btnTripinfo), for: .normal)
        btn.addTarget(self, action: #selector(pushToTravelInfoVC), for: .touchUpInside)
        return btn
    }()
    
    private weak var viewController: UIViewController?
    private let type: NavigationBarType
    weak var delegate: DOONavigationBarDelegate?
    
    init(_ viewController: UIViewController, type: NavigationBarType, backgroundColor: UIColor = UIColor(resource: .white000)) {
        self.viewController = viewController
        self.type = type
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setStyle()
        setNavibarByType()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DOONavigationBar {
    func setStyle() {
        self.backgroundColor = .clear
    }
    
    func setNavibarByType() {
        switch type {
        case .backButtonOnly:
            addSubview(backButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            
        case .ourToDo, .myToDo:
            addSubviews(backButton, travelInfoButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            travelInfoButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            backButton.removeTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
            backButton.addTarget(self, action: #selector(popToRootVC), for: .touchUpInside)
            
        case .titleLabelOnly(let title):
            titleLabel.text = title
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        case .backButtonWithTitle(let title):
            titleLabel.text = title
            addSubviews(titleLabel, backButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
        case .testResult:
            saveImageButton.snp.makeConstraints {
                $0.width.height.equalTo(ScreenUtils.getHeight(48))
                $0.trailing.equalToSuperview().inset(10)
            }
        
        case .rightItemWithTitle(let title):
            titleLabel.text = title
            addSubviews(titleLabel, backButton, saveTextButton)
            titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            saveTextButton.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.height.equalTo(23)
                $0.trailing.equalToSuperview().inset(23)
            }
        }
        
    }
    
    @objc
    func popToPreviousVC() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func pushToMyProfileVC() {
        let vc = MyProfileViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func popToRootVC() {
        viewController?.tabBarController?.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func saveImageButtonTapped() {
        
    }
    
    @objc
    func saveTitleButtonTapped() {
        print("tap")
        self.delegate?.saveTextButtonTapped()
    }
  
    @objc
    func pushToTravelInfoVC() {
        self.delegate?.pushToTravelInfoVC()
    }
}

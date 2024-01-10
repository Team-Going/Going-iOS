//
//  DOONavigationBar.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/9/24.
//

import UIKit

import SnapKit

final class DOONavigationBar: UIView {
    
    enum NavigationBarType {
        case backButtonOnly
        case ourToDo
        case myToDo
        case titleLabelOnly(String)
        case backButtonWithTitle(String)
    }
        
    private lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.NavigationBar.buttonBack, for: .normal)
        btn.addTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
        btn.addTarget(self, action: #selector(popToRootVC), for: .touchUpInside)
        return btn
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body1_bold)
        label.textColor = .gray700
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let btn = UIButton()
        btn.setImage(ImageLiterals.NavigationBar.buttonProfile, for: .normal)
        btn.addTarget(self, action: #selector(pushToMyProfileVC), for: .touchUpInside)
        return btn
    }()
    
    private weak var viewController: UIViewController?
    private let type: NavigationBarType
    
    init(_ viewController: UIViewController, type: NavigationBarType, backgroundColor: UIColor = .white000) {
        self.viewController = viewController
        self.type = type
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        setStyle()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DOONavigationBar {
    func setStyle() {
        self.backgroundColor = .clear
    }
    
    func setLayout() {
        switch type {
        case .backButtonOnly:
            addSubview(backButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            
        case .ourToDo:
            addSubview(backButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            backButton.removeTarget(self, action: #selector(popToPreviousVC), for: .touchUpInside)
            backButton.addTarget(self, action: #selector(popToRootVC), for: .touchUpInside)
            
        case .myToDo:
            addSubviews(backButton, profileButton)
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(10)
                $0.centerY.equalToSuperview()
            }
            profileButton.snp.makeConstraints {
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
    
    @objc func popToRootVC() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}

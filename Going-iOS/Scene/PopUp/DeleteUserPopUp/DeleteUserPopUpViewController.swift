//
//  DeleteUserPopUpViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

import SnapKit

final class DeleteUserPopUpViewController: PopUpDimmedViewController {
    
    private let popUpView = DOOPopUpContainerView()
    
    private let deleteUserLabel = DOOLabel(font: .pretendard(.body1_bold), color: .gray600, text: "정말 탈퇴하시겠어요?")
    private let deleteUserDescLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray300, text: "탈퇴시, 정보가 모두 없어져요.")
    
    private lazy var deleteUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = .gray50
        button.addTarget(self, action: #selector(delteUserButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("남아있기", for: .normal)
        button.setTitleColor(.white000, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = .gray500
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()

    }
}

private extension DeleteUserPopUpViewController {
    
    func setHierarchy() {
        view.addSubview(popUpView)
        popUpView.addSubviews(deleteUserLabel, deleteUserDescLabel, deleteUserButton, backButton)
    }
    
    func setLayout() {
        
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(270))
            $0.height.equalTo(ScreenUtils.getHeight(140))

        }
        
        deleteUserLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        deleteUserDescLabel.snp.makeConstraints {
            $0.top.equalTo(deleteUserLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        deleteUserButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.width.equalTo(ScreenUtils.getWidth(135))
            $0.leading.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.width.equalTo(ScreenUtils.getWidth(135))
            $0.trailing.equalToSuperview()
        }
    }
    
    @objc
    func delteUserButtonTapped() {
        print("회원탈퇴 네트워크 통신")
    }
    
    @objc
    func backButtonTapped() {
        self.dismiss(animated: false)
    }
}

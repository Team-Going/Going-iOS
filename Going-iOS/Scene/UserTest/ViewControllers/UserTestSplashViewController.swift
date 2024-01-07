//
//  UserTestSplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class UserTestSplashViewController: UIViewController {

    private let titleLabel = DOOLabel(font: .pretendard(.head3),
                                      color: .gray700,
                                      text: StringLiterals.UserTest.userTestSplashTitle,
                                      numberOfLine: 2,
                                      alignment: .center)
    
    private let userTestSplashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemOrange
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.textColor = .white000
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.layer.cornerRadius = 6
        button.backgroundColor = .gray500
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHierarchy()
        setLayout()
        setStyle()

    }
}

private extension UserTestSplashViewController {
    
    func setHierarchy() {
        view.addSubviews(titleLabel, userTestSplashImageView, nextButton)
    }
    
    func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(209)
            $0.leading.trailing.equalToSuperview().inset(87)
        }
        
        userTestSplashImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(87)
            $0.height.equalTo(ScreenUtils.getHeight(126))
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
    }
    
    func setStyle() {
        view.backgroundColor = .white000
    }
    
    @objc func nextButtonTapped() {
        let nextVC = UserTestViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

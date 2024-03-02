//
//  UserTestSplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class UserTestSplashViewController: UIViewController {
    
    private let userTestSplashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .imgTestsplash)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = DOOLabel(font: .pretendard(.head3),
                                      color: UIColor(resource: .gray700),
                                      text: StringLiterals.UserTest.userTestSplashTitle,
                                      alignment: .center
                                      )
    
    private let subTitleLabel = DOOLabel(font: .pretendard(.body3_medi),
                                      color: UIColor(resource: .gray300),
                                      text: StringLiterals.UserTest.userTestSplashSubTitle,
                                      numberOfLine: 2,
                                      alignment: .center
                                      )
    
    private lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("테스트 건너뛰기", for: .normal)
        button.setTitleColor(UIColor(resource: .gray300), for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setUnderline()
        button.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        return button
    }()
  
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("테스트 시작하기", for: .normal)
        button.setTitleColor(UIColor(resource: .white000), for: .normal)
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.backgroundColor = UIColor(resource: .gray500)
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
    }
}

private extension UserTestSplashViewController {
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(userTestSplashImageView, titleLabel, subTitleLabel, skipButton, nextButton)
    }
    
    func setLayout() {
        userTestSplashImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(202)
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(userTestSplashImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(78))
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(68))
        }
    }
    
    func setStyle() {
        view.backgroundColor = UIColor(resource: .white000)
    }
    
    @objc func nextButtonTapped() {
        let nextVC = UserTestViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func skipButtonTapped() {
        let nextVC = DashBoardViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

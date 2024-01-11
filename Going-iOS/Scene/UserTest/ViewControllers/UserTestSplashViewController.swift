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
        imageView.image = ImageLiterals.Splash.userTestSplash
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = DOOLabel(font: .pretendard(.head3),
                                      color: .gray700,
                                      text: StringLiterals.UserTest.userTestSplashTitle,
                                      alignment: .center
                                      )
    
    private let subTitleLabel = DOOLabel(font: .pretendard(.body3_medi),
                                      color: .gray300,
                                      text: StringLiterals.UserTest.userTestSplashSubTitle,
                                      numberOfLine: 2,
                                      alignment: .center
                                      )
  
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("테스트 시작하기", for: .normal)
        button.titleLabel?.textColor = .white000
        button.titleLabel?.font = .pretendard(.body1_bold)
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
        view.addSubviews(userTestSplashImageView, titleLabel, subTitleLabel ,nextButton)
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
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(68))
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

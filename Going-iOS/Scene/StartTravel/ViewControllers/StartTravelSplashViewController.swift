//
//  StartTravelSplashViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/8/24.
//

import UIKit

final class StartTravelSplashViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonOnly)
    
    private let characterImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(resource: .imgTripSplash)
        return img
    }()
    
    private let startTravelTitleLabel = DOOLabel(font: .pretendard(.head3),
                                                 color: .gray700,
                                                 text: StringLiterals.StartTravel.startTravelTitle,
                                                 numberOfLine: 2,
                                                 alignment: .center)
    
    private lazy var createTravelButton: DOOButton = {
        let btn = DOOButton(type: .white, title: "새로운 여행 만들기")
        btn.addTarget(self, action: #selector(createTravelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var joinTravelButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "초대받은 여행 입장하기")
        btn.addTarget(self, action: #selector(joinTravelButtonTapped), for: .touchUpInside)
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

private extension StartTravelSplashViewController {
    func setStyle() {
        self.view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        self.view.addSubviews(navigationBar,
                              characterImage,
                              startTravelTitleLabel,
                              createTravelButton,
                              joinTravelButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        characterImage.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(230))
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(152))
            $0.centerX.equalToSuperview()
        }
        
        startTravelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(characterImage.snp.bottom).offset(ScreenUtils.getHeight(18))
            $0.centerX.equalToSuperview()
        }
        
        createTravelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(joinTravelButton.snp.top).offset(ScreenUtils.getHeight(-12))
        }
        
        joinTravelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(ScreenUtils.getHeight(-6))
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func createTravelButtonTapped() {
        let vc = CreateTravelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func joinTravelButtonTapped() {
        let vc = JoinTravelViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

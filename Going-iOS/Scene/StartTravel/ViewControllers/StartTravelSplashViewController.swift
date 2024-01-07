//
//  StartTravelSplashViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/8/24.
//

import UIKit

class StartTravelSplashViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let startTravelTitleLabel = DOOLabel(font: .pretendard(.head3), 
                                                 color: .gray700,
                                                 text: StringLiterals.StartTravel.startTravelTitle)
    
    private let startTravelButton = DOOButton(type: .white, title: "새로운 여행 시작하기")
    private let joinTravelButton = DOOButton(type: .enabled, title: "여행 입장하기")
    
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
    }
    
    func setHierarchy() {
        self.view.addSubviews(startTravelTitleLabel, startTravelButton, joinTravelButton)
    }
    
    func setLayout() {
        startTravelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(224)
            $0.centerX.equalToSuperview()
        }
        
        startTravelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(joinTravelButton.snp.top).offset(-12)
        }
        
        joinTravelButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
        }
    }
}

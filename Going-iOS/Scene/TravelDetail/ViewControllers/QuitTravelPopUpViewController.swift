//
//  QuitTravelPopUpViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/2/24.
//

import UIKit

import SnapKit

final class QuitTravelPopUpViewController: PopUpDimmedViewController {
    
    // MARK: - UI Properties
    
    private let popUpView = DOOPopUpContainerView()
    
    private let quitTravelLabel = DOOLabel(font: .pretendard(.body1_bold),
                                           color: UIColor(resource: .gray600),
                                           text: "여행방 나가기")
    
    private let quitTravelDescLabel: DOOLabel = {
        let label = DOOLabel(font: .pretendard(.detail2_regular),
                             color: UIColor(resource: .gray300),
                             text: "나가기를 하면 정보가 모두 삭제되고,\n여행 목록에서도 삭제됩니다")
        label.numberOfLines = 2
        label.setLineSpacing(spacing: 3)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(resource: .gray300), for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = UIColor(resource: .gray50)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var quitButton: UIButton = {
        let button = UIButton()
        button.setTitle("나가기", for: .normal)
        button.setTitleColor(UIColor(resource: .white000), for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = UIColor(resource: .gray500)
        button.addTarget(self, action: #selector(quitButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
    }
}

// MARK: - Private Methods

private extension QuitTravelPopUpViewController {
    func setHierarchy() {
        view.addSubview(popUpView)
        
        popUpView.addSubviews(quitTravelLabel,
                              quitTravelDescLabel,
                              cancelButton,
                              quitButton)
    }
    
    func setLayout() {
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(270))
            $0.height.equalTo(ScreenUtils.getHeight(158))
        }
        
        quitTravelLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        quitTravelDescLabel.snp.makeConstraints {
            $0.top.equalTo(quitTravelLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(174))
            $0.bottom.equalTo(cancelButton.snp.top).offset(-20)
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.width.equalTo(ScreenUtils.getWidth(135))
            $0.leading.equalToSuperview()
        }
        
        quitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.width.equalTo(ScreenUtils.getWidth(135))
            $0.trailing.equalToSuperview()
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func cancelButtonTapped() {
        self.dismiss(animated: false)
    }
    
    @objc
    func quitButtonTapped() {
        print("button tapped")
        // TODO: - 여행 나가기 서버 통신
    }
}

//
//  JoiningSuccessViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class JoiningSuccessViewController: UIViewController {

    // MARK: - UI Properties
    
    // TODO: - Dummy Data 생성
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonOnly, backgroundColor: .gray50)
    
    private let joinSuccessLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head2)
        label.textColor = .gray700
        label.text = StringLiterals.JoiningSuccess.title
        label.numberOfLines = 0
        return label
    }()
    
    private let ticketImage: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.CreateTravel.ticketImage
        return img
    }()
    
    private let characterImage: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.CreateTravel.larvaImage
        return img
    }()
    
    private let dDayLabelBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .red100
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let dDayLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.detail2_bold)
        label.textColor = .red400
        label.text = "D-16"
        return label
    }()
    
    private let travelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body1_bold)
        label.textColor = .gray700
        label.text = "두릅과 스페인"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.detail3_regular)
        label.textColor = .gray300
        label.text = "12월 16일 - 12월 25일"
        return label
    }()

    private let entranceToTestButton = DOOButton(type: .enabled, title: "입장하기")
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
    }
}

// MARK: - Private Extension

private extension JoiningSuccessViewController {
    
    func setStyle() {
        view.backgroundColor = .gray50
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         joinSuccessLabel,
                         ticketImage,
                         entranceToTestButton)
        
        ticketImage.addSubviews(characterImage, dDayLabelBackgroundView, travelTitleLabel, dateLabel)
        dDayLabelBackgroundView.addSubview(dDayLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        joinSuccessLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(256)
            $0.leading.equalToSuperview().inset(64)
            $0.trailing.equalToSuperview().inset(65)
        }
        
        ticketImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(joinSuccessLabel.snp.bottom).offset(24)
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.height.equalTo(ScreenUtils.getHeight(125))
        }
        
        characterImage.snp.makeConstraints {
            $0.centerY.equalTo(ticketImage)
            $0.leading.equalTo(ticketImage.snp.leading).offset(22)
        }
        
        dDayLabelBackgroundView.snp.makeConstraints {
            $0.leading.equalTo(ticketImage.snp.leading).offset(102)
            $0.bottom.equalTo(travelTitleLabel.snp.top).offset(-4)
            $0.height.equalTo(ScreenUtils.getHeight(22))
            $0.width.equalTo(ScreenUtils.getWidth(44))
        }
        
        dDayLabel.snp.makeConstraints {
            $0.center.equalTo(dDayLabelBackgroundView)
        }
        
        travelTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(characterImage)
            $0.leading.equalTo(dDayLabelBackgroundView)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(travelTitleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(travelTitleLabel)
        }
        
        entranceToTestButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
}

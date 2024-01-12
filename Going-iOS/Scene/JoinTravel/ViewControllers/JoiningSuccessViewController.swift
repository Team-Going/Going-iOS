//
//  JoiningSuccessViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class JoiningSuccessViewController: UIViewController {
        
    // MARK: - Network

    var joinSuccessData: JoiningSuccessAppData? {
        didSet {
            guard let data = joinSuccessData else { return }
            self.travelTitleLabel.text = data.travelName
            self.dateLabel.text = data.startDate + "-" + data.endDate
            self.dDayLabel.text = "D-" + "\(data.dueDate)"
        }
    }
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonOnly, backgroundColor: .gray50)
    
    private let joinSuccessLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head2)
        label.textColor = .gray700
        label.text = StringLiterals.JoiningSuccess.title
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let letterImage: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.JoinTravel.imgJoinMessage
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
//        label.text = "D-16"
        return label
    }()
    
    private let travelTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .gray700
//        label.text = "두릅과 스페인"
        return label
    }()
    
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.detail3_regular)
        label.textColor = .gray300
//        label.text = "12월 16일 - 12월 25일"
        return label
    }()
    
    private lazy var entranceButton: DOOButton = {
        let btn =  DOOButton(type: .enabled, title: StringLiterals.JoiningSuccess.confirmButton)
        btn.addTarget(self, action: #selector(pushToTravelTestVC), for: .touchUpInside)
        return btn
    }()
    
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
                         letterImage,
                         entranceButton)
        
        letterImage.addSubviews(dDayLabelBackgroundView, travelTitleLabel, dateLabel)
        dDayLabelBackgroundView.addSubview(dDayLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        joinSuccessLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(86)
            $0.centerX.equalToSuperview()
        }
        
        letterImage.snp.makeConstraints {
            $0.top.equalTo(joinSuccessLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(39)
            $0.width.equalTo(ScreenUtils.getWidth(320))
            $0.height.equalTo(ScreenUtils.getHeight(300))
        }
        
        dDayLabelBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(51)
            $0.centerX.equalTo(joinSuccessLabel)
            $0.width.equalTo(ScreenUtils.getWidth(50))
            $0.height.equalTo(ScreenUtils.getHeight(22))
        }
        
        dDayLabel.snp.makeConstraints {
            $0.center.equalTo(dDayLabelBackgroundView)
        }
        
        travelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabelBackgroundView.snp.bottom).offset(8)
            $0.centerX.equalTo(dDayLabelBackgroundView)
            $0.height.equalTo(ScreenUtils.getHeight(30))
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(travelTitleLabel.snp.bottom).offset(2)
            $0.centerX.equalTo(dDayLabelBackgroundView)
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        entranceButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func pushToTravelTestVC() {
        let vc = TravelTestViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

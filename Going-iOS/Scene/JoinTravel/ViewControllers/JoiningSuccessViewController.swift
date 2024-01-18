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
    
    var tripId: Int = 0
    
    var joinSuccessData: JoiningSuccessAppData? {
        didSet {
            guard let data = joinSuccessData else { return }
            self.travelTitleLabel.text = data.travelName
            self.dateLabel.text = data.startDate + "-" + data.endDate
            self.tripId = data.travelId
            
            if data.dueDate <= 0 {
                self.dDayLabel.text = "여행 중"
            } else {
                self.dDayLabel.text = "D-\(data.dueDate)"
            }
            
            self.dDayLabel.backgroundColor = .red100
            self.dDayLabel.textColor = .red500
        }
    }
    
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonOnly, backgroundColor: .gray50)
    
    private let joinSuccessLabel = DOOLabel(font: .pretendard(.head2), color: .gray700, text: StringLiterals.JoiningSuccess.title, numberOfLine: 2, alignment: .center)
    
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
    
    private let dDayLabel = DOOLabel(font: .pretendard(.detail2_bold), color: .red400)
    
    private let travelTitleLabel = DOOLabel(font: .pretendard(.head3), color: .gray700)
    
    private let dateLabel = DOOLabel(font: .pretendard(.detail3_regular), color: .gray300)
    
    private lazy var entranceButton: DOOButton = {
        let btn =  DOOButton(type: .enabled, title: StringLiterals.JoiningSuccess.confirmButton)
        btn.addTarget(self, action: #selector(entranceButtonTapped), for: .touchUpInside)
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
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(86))
            $0.centerX.equalToSuperview()
        }
        
        letterImage.snp.makeConstraints {
            $0.top.equalTo(joinSuccessLabel.snp.bottom).offset(ScreenUtils.getHeight(20))
            $0.leading.equalToSuperview().inset(ScreenUtils.getWidth(39))
            $0.width.equalTo(ScreenUtils.getWidth(320))
            $0.height.equalTo(ScreenUtils.getHeight(300))
        }
        
        dDayLabelBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(51))
            $0.centerX.equalTo(joinSuccessLabel)
            $0.width.equalTo(ScreenUtils.getWidth(50))
            $0.height.equalTo(ScreenUtils.getHeight(22))
        }
        
        dDayLabel.snp.makeConstraints {
            $0.center.equalTo(dDayLabelBackgroundView)
        }
        
        travelTitleLabel.snp.makeConstraints {
            $0.top.equalTo(dDayLabelBackgroundView.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.centerX.equalTo(dDayLabelBackgroundView)
            $0.height.equalTo(ScreenUtils.getHeight(30))
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(travelTitleLabel.snp.bottom).offset(ScreenUtils.getHeight(2))
            $0.centerX.equalTo(dDayLabelBackgroundView)
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        entranceButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(ScreenUtils.getHeight(6))
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func entranceButtonTapped() {
        let vc = JoinTravelTestViewController()
        vc.tripId = tripId
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  CreatingSuccessViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit

final class CreatingSuccessViewController: UIViewController {
    
    // MARK: - UI Properties
    
    // TODO: - Dummy Data 생성
    
    private let navigationBar: NavigationView = {
        let nav = NavigationView()
        nav.titleLabel.text = ""
        nav.backgroundColor = .gray50
        return nav
    }()
    
    private let createSuccessLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head2)
        label.textColor = .gray700
        label.text = StringLiterals.CreatingSuccess.title
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
    
    private let inviteTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body1_bold)
        label.textColor = .gray700
        label.text = StringLiterals.CreatingSuccess.inviteCodeTitle
        return label
    }()
    
    private let inviteCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white000
        view.layer.cornerRadius = 6
        return view
    }()
    
    private let inviteCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head4)
        label.textColor = .black000
        label.text = "083549"
        return label
    }()
    
    private let codeCopyButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.CreatingSuccess.copyCode, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(.gray300, for: .normal)
        button.setImage(ImageLiterals.CreateTravel.buttonCopy, for: .normal)
        return button
    }()
    
    private let sendToKaKaoButton = DOOButton(type: .white, title: "카카오톡으로 초대코드 보내기")
    private let entranceToMainButton = DOOButton(type: .enabled, title: "입장하기")
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierachy()
        setLayout()
    }
}

// MARK: - Private Extension

private extension CreatingSuccessViewController {
    
    func setStyle() {
        view.backgroundColor = .gray50
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierachy() {
        view.addSubviews(navigationBar,
                         createSuccessLabel,
                         ticketImage,
                         inviteTitleLabel,
                         inviteCardView,
                         sendToKaKaoButton,
                         entranceToMainButton)
        
        ticketImage.addSubviews(characterImage, dDayLabelBackgroundView, travelTitleLabel, dateLabel)
        dDayLabelBackgroundView.addSubview(dDayLabel)
        inviteCardView.addSubviews(inviteCodeLabel, codeCopyButton)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        createSuccessLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(64)
            $0.leading.equalToSuperview().inset(64)
            $0.trailing.equalToSuperview().inset(65)
        }
        
        ticketImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(createSuccessLabel.snp.bottom).offset(28)
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
        
        inviteTitleLabel.snp.makeConstraints {
            $0.top.equalTo(ticketImage.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        inviteCardView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inviteTitleLabel.snp.bottom).offset(8)
            $0.height.equalTo(ScreenUtils.getHeight(83))
            $0.width.equalTo(ScreenUtils.getWidth(327))
        }
        
        inviteCodeLabel.snp.makeConstraints {
            $0.top.equalTo(inviteCardView.snp.top).offset(16)
            $0.centerX.equalTo(inviteCardView)
        }
        
        codeCopyButton.snp.makeConstraints {
            $0.bottom.equalTo(inviteCardView.snp.bottom).inset(16)
            $0.centerX.equalTo(inviteCardView)
        }
        
        sendToKaKaoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(entranceToMainButton.snp.top).offset(-12)
        }
        
        entranceToMainButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
        }
    }
}

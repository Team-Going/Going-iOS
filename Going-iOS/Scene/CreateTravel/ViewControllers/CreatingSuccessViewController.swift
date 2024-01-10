//
//  CreatingSuccessViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/5/24.
//

import UIKit

import SnapKit
import KakaoSDKTemplate
import KakaoSDKCommon
import KakaoSDKShare

final class CreatingSuccessViewController: UIViewController {
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonOnly, backgroundColor: .gray50)
    
    private let createSuccessLabel = DOOLabel(font: .pretendard(.head2), color: .gray700, text: StringLiterals.CreatingSuccess.title)
    
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
    
    private let dDayLabel = DOOLabel(font: .pretendard(.detail2_bold), color: .red400)
    private let travelTitleLabel = DOOLabel(font: .pretendard(.body1_bold), color: .gray700)
    private let dateLabel = DOOLabel(font: .pretendard(.detail3_regular), color: .gray300)
    
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
    private let inviteCodeLabel = DOOLabel(font: .pretendard(.head4), color: .gray700)

    private lazy var codeCopyButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.CreatingSuccess.copyCode, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(.gray300, for: .normal)
        button.setImage(ImageLiterals.CreateTravel.buttonCopy, for: .normal)
        button.addTarget(self, action: #selector(copyButtonTapped), for: .touchUpInside)
        return button
    }()
    private let codeUnderLineView: UIView = {
        let line = UIView()
        line.backgroundColor = .gray300
        return line
    }()
    
    private lazy var sendToKaKaoButton: DOOButton = {
        let btn = DOOButton(type: .white, title: "카카오톡으로 초대코드 보내기")
        btn.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var entranceToMainButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "입장하기")
        btn.addTarget(self, action: #selector(entranceButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setData(data: CreateTravelStruct.createTravelDummy)
    }
}

// MARK: - Private Extension

private extension CreatingSuccessViewController {
    func setStyle() {
        view.backgroundColor = .gray50
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         createSuccessLabel,
                         ticketImage,
                         inviteTitleLabel,
                         inviteCardView,
                         sendToKaKaoButton,
                         entranceToMainButton)
        
        ticketImage.addSubviews(characterImage, dDayLabelBackgroundView, travelTitleLabel, dateLabel)
        dDayLabelBackgroundView.addSubview(dDayLabel)
        inviteCardView.addSubviews(inviteCodeLabel, codeUnderLineView, codeCopyButton)
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
            $0.leading.equalTo(characterImage.snp.trailing).offset(50)
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
            $0.bottom.equalToSuperview().inset(26)
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
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalTo(inviteCardView)
        }
        
        codeCopyButton.snp.makeConstraints {
            $0.bottom.equalTo(inviteCardView.snp.bottom).inset(16)
            $0.centerX.equalTo(inviteCardView)
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(112))
        }
        
        codeUnderLineView.snp.makeConstraints {
            $0.top.equalTo(codeCopyButton.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(102))
            $0.height.equalTo(0.5)
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
    
    func setData(data: CreateTravelStruct) {
        self.dDayLabel.text = "D-" + "\(data.dueDate)"
        self.travelTitleLabel.text = data.travelTitle
        self.dateLabel.text = data.travelDate
        self.inviteCodeLabel.text = data.inviteCode
    }
    
    func sendKakaoMessage() {
        let templateId = Constant.KaKaoMessageTemplate.id
        
        // 카카오톡 설치여부 확인
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {(sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        else {
            // 카카오톡 미설치 시, 웹 뷰
            if ShareApi.shared.makeCustomUrl(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) != nil {
                let kakaoVC = WebViewController(urlString: "https://accounts.kakao.com")
                self.present(kakaoVC, animated: true)
            }
        }
    }

    // MARK: - @objc Methods
    
    @objc
    func copyButtonTapped() {
        DOOToast.show(message: "초대코드가 복사되었어요.", insetFromBottom: ScreenUtils.getHeight(284))
        UIPasteboard.general.string = inviteCodeLabel.text
    }
    
    @objc
    func kakaoButtonTapped() {
       sendKakaoMessage()
    }
    
    @objc
    func pushToOurToDoVC() {
        let vc = OurToDoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

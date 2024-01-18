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
    
    // MARK: - Network

    var createTravelResponseData: CreateTravelResponseAppData? {
        didSet {
            guard let data = createTravelResponseData else { return }
            self.travelTitleLabel.text = data.title
            self.dateLabel.text = data.startDate + "-" + data.endDate
            self.inviteCodeLabel.text = data.code
            let vc = OurToDoViewController()
            if data.day <= 0 {
                self.dDayLabel.text = "여행 중"
            } else {
                self.dDayLabel.text = "D-" + "\(data.day)"
            }
            if let tripId = self.createTravelResponseData?.tripId {
                vc.tripId = tripId
            } else { return }
        }
    }

    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonOnly, backgroundColor: .gray50)
    
    private let createSuccessLabel = DOOLabel(font: .pretendard(.head2), color: .gray700, text: StringLiterals.CreatingSuccess.title)
    private let characterImage: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.StartTravelSplash.imgTripSplash
        return img
    }()
    
    private let ticketImage: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.CreateTravel.ticketLargeImage
        img.isUserInteractionEnabled = true
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
    private let dateLabel = DOOLabel(font: .pretendard(.detail1_regular), color: .gray300)
    
    private let inviteCodeLabel = DOOLabel(font: .pretendard(.body1_medi), color: .gray700)

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
        let btn = DOOButton(type: .white, title: StringLiterals.CreatingSuccess.kakaoBtn)
        btn.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var entranceToMainButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: StringLiterals.CreatingSuccess.entranceBtn)
        btn.addTarget(self, action: #selector(pushToOurToDoVC), for: .touchUpInside)
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

private extension CreatingSuccessViewController {
    func setStyle() {
        view.backgroundColor = .gray50
        self.navigationController?.isNavigationBarHidden = true
        navigationBar.isHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         createSuccessLabel,
                         ticketImage,
                         characterImage,
                         sendToKaKaoButton,
                         entranceToMainButton)

        ticketImage.addSubviews(dDayLabelBackgroundView, 
                                travelTitleLabel,
                                dateLabel,
                                inviteCodeLabel,
                                codeUnderLineView,
                                codeCopyButton)
        dDayLabelBackgroundView.addSubview(dDayLabel)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        createSuccessLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(ScreenUtils.getHeight(76))
            $0.centerX.equalToSuperview()
        }
        
        characterImage.snp.makeConstraints {
            $0.top.equalTo(createSuccessLabel.snp.bottom).offset(ScreenUtils.getHeight(12))
            $0.width.equalTo(ScreenUtils.getWidth(218))
            $0.height.equalTo(ScreenUtils.getHeight(132))
            $0.centerX.equalToSuperview()
        }
        
        ticketImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(createSuccessLabel.snp.bottom).offset(ScreenUtils.getHeight(118))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.height.equalTo(ScreenUtils.getHeight(235))
        }

        dDayLabelBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(ScreenUtils.getHeight(38))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(20))
            $0.width.equalTo(ScreenUtils.getWidth(44))
        }
        
        dDayLabel.snp.makeConstraints {
            $0.center.equalTo(dDayLabelBackgroundView)
        }
        
        travelTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dDayLabelBackgroundView.snp.bottom).offset(ScreenUtils.getHeight(8))
            $0.height.equalTo(ScreenUtils.getHeight(30))
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(travelTitleLabel.snp.bottom).offset(ScreenUtils.getHeight(2))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }

        inviteCodeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(42))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(27))
        }
        
        codeCopyButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(ScreenUtils.getHeight(20))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(110))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        codeUnderLineView.snp.makeConstraints {
            $0.top.equalTo(codeCopyButton.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(codeCopyButton)
            $0.height.equalTo(1)
        }

        sendToKaKaoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(entranceToMainButton.snp.top).offset(ScreenUtils.getHeight(-12))
        }
        
        entranceToMainButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(ScreenUtils.getHeight(6))
        }
    }

    func sendKakaoMessage() {
        let templateId = Constant.KaKaoMessageTemplate.id
        guard let filteredString = self.inviteCodeLabel.text else { return }
        guard let filteredTitle = self.travelTitleLabel.text else { return }
        let inviteCode =  String(filteredString)
        let travelTitle = String(filteredTitle)
        
        // 카카오톡 설치여부 확인
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: Int64(templateId) , templateArgs:["KEY":"\(inviteCode)", "NAME":"\(travelTitle)"]) {(sharingResult, error) in
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
        DOOToast.show(message: "초대코드가 복사되었어요", insetFromBottom: ScreenUtils.getHeight(228))
        UIPasteboard.general.string = inviteCodeLabel.text
    }
    
    @objc
    func kakaoButtonTapped() {
       sendKakaoMessage()
    }
    
    @objc
    func pushToOurToDoVC() {
        let vc = DOOTabbarViewController()
        if let ourtodoVC = vc.ourTODoVC.viewControllers[0] as? OurToDoViewController,
           let myToDoVC = vc.myToDoVC.viewControllers[0] as? MyToDoViewController {
            ourtodoVC.tripId = self.createTravelResponseData?.tripId ?? 0
            myToDoVC.tripId = self.createTravelResponseData?.tripId ?? 0
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  LoginViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import AuthenticationServices
import SnapKit


final class LoginViewController: UIViewController {
    
    private enum Size {
        static let logoHeight: CGFloat = 66 / 194
        static let ButtonHeight: CGFloat = 44 / 300
        static let personalHeight: CGFloat = 20 / 99

        
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = StringLiterals.Login.title
        label.textColor = .gray500
        label.font = .pretendard(.head3)
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Login.loginLogo
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.Login.appleLoginButton, for: .normal)
        button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(ImageLiterals.Login.kakaoLoginButton, for: .normal)
        //            button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var personalInformationButton: UIButton = {

//        var config = UIButton.Configuration.plain()
//        var title = AttributedString.init(StringLiterals.Login.personalInformation)
//        title.font = .pretendard(.detail2_regular)
//        title.strokeColor = .gray300
//        config.attributedTitle = title
//
//        config.image = ImageLiterals.Login.warningImage
//        config.imagePlacement = .leading
//        let button = UIButton(configuration: config)
        
        let button = UIButton()
        button.setTitle(StringLiterals.Login.personalInformation, for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setImage(ImageLiterals.Login.warningImage, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    private func setHierarchy() {
        self.view.addSubviews(titleLabel, logoImageView, appleLoginButton, kakaoLoginButton, personalInformationButton, underLineView)
    }
    
    private func setLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(282)
            $0.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(91)
            $0.height.equalTo(logoImageView.snp.width).multipliedBy(Size.logoHeight)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(204)
            $0.trailing.leading.equalToSuperview().inset(38)
            $0.height.equalTo(appleLoginButton.snp.width).multipliedBy(Size.ButtonHeight)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(12)
            $0.trailing.leading.equalToSuperview().inset(38)
            $0.height.equalTo(appleLoginButton.snp.width).multipliedBy(Size.ButtonHeight)
        }
        
        personalInformationButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(8)
            $0.trailing.leading.equalToSuperview().inset(138)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(personalInformationButton.snp.bottom)
            $0.leading.equalTo(personalInformationButton.snp.leading)
            $0.trailing.equalTo(personalInformationButton.snp.trailing).offset(-15)
            $0.height.equalTo(1)
        }
    }
    
    private func setStyle() {
        self.view.backgroundColor = .white000
    }
    
    
    @objc
    private func appleLoginButtonTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    //애플로그인 성공했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            //이거로 자동로그인 판별
            let userIdentifier = credential.user
            
            // .authorizationCode와 .identityToken은 Generate and valid tokens, revoke tokens에서 사용
            
        }
    }
    
    //애플로그인 실패했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failed - \(error.localizedDescription)")
        
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
}

//
//  LoginViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser
import SnapKit


final class LoginViewController: UIViewController {
    
    private var kakaoAccessToken: String? {
        didSet {
            guard let token = kakaoAccessToken else { return }
            print("여기서 로그인에이피아이이ㅣ이")
            //로그인API
        }
    }
    
    private let titleLabel = DOOLabel(font: .pretendard(.head3), color: .gray500, text: StringLiterals.Login.title)
    
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
                    button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var personalInformationButton: UIButton = {
        let button = UIButton()
        button.setTitle(StringLiterals.Login.personalInformation, for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setImage(ImageLiterals.Login.warningImage, for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(webViewButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNaviBar()
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    
}

private extension LoginViewController {
    func hideNaviBar() {
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    func setHierarchy() {
        self.view.addSubviews(titleLabel,
                              logoImageView,
                              appleLoginButton,
                              kakaoLoginButton,
                              personalInformationButton,
                              underLineView)
    }
    
    func setLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(282)
            $0.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(91)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-12)
            $0.trailing.leading.equalToSuperview().inset(38)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(personalInformationButton.snp.top).offset(-8)
            $0.trailing.leading.equalToSuperview().inset(38)
        }
        
        personalInformationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.width.equalTo(ScreenUtils.getWidth(99))
            $0.centerX.equalTo(kakaoLoginButton)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(personalInformationButton.snp.bottom)
            $0.leading.equalTo(personalInformationButton.snp.leading)
            $0.trailing.equalTo(personalInformationButton.snp.trailing)
            $0.height.equalTo(1)
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .white000
    }
    

    private func loginKakaoWithApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            guard error == nil else { return }
            print("Login with KAKAO App Success !!")
            guard let oAuthToken = oAuthToken else { return }
            print(oAuthToken.accessToken)
            self.kakaoAccessToken = oAuthToken.accessToken

        }
    }
    
    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            guard error == nil else { return }
            print("Login with KAKAO Web Success !!")
            guard let oAuthToken = oAuthToken else { return }
            print(oAuthToken.accessToken)
            self.kakaoAccessToken = oAuthToken.accessToken
        }
    }
    
    @objc
    func kakaoLoginButtonTapped() {
        
        //카카오톡앱이 있으면 카카오앱으로 연결, 없으면 웹을 띄워줌
        if UserApi.isKakaoTalkLoginAvailable() {
            loginKakaoWithApp()
        } else {
            loginKakaoWithWeb()
        }
        //뷰연결 테스트용도
//        let nextVC = MakeProfileViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    func appleLoginButtonTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
        //뷰연결용
        let nextVC = MakeProfileViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc
    func webViewButtonTapped() {
        let vc = PersonalInfoWebViewController()
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
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



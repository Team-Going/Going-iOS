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
    
//회원가입으로 갈 때 필요함, 이거를 UserDefault에 가지고 있는게 좋은 지, 그냥 이런 식으로 다음 뷰컨으로 넘겨도 되는지?
    
    var socialType: SocialPlatform?
    
    private var socialToken: String? {
        didSet {
            guard let token = socialToken else { return }
            guard let platform = socialType else { return }
            //로그인API
            Task {
                do {
                    let isPushToDashView = try await AuthService.shared.postLogin(token: token, platform: platform)
                    
                    //true면 대시보드로 이동
                    if isPushToDashView {
                        let nextVC = DashBoardViewController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        //성향테스트스플래시뷰로 이동
                        let nextVC = UserTestSplashViewController()
//                        nextVC.socialToken = self.socialToken

                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
                catch {
                    guard let error = error as? NetworkError else { return }
                    handleError(error)
                }
            }
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
        var config = UIButton.Configuration.filled()
        config.title = "카카오 로그인"
        config.titleAlignment = .center
        config.image = ImageLiterals.Login.kakaoLoginButton
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: ScreenUtils.getWidth(92))
        
        config.imagePadding = ScreenUtils.getWidth(70)

        config.baseBackgroundColor = .yellow100
        config.baseForegroundColor = .black000.withAlphaComponent(0.85)
        
        let button = UIButton(configuration: config)
        
        
//        button.setImage(ImageLiterals.Login.kakaoLoginButton, for: .normal)
//        button.backgroundColor = .yellow100
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        button.layer.cornerRadius = 8
//        button.setTitle("카카오 로그인", for: .normal)
//        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.85), for: .normal)
//
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
    
    func disableLoginButton() {
        self.kakaoLoginButton.isEnabled = false
        self.appleLoginButton.isEnabled = false
    }
    
    func ableLoginButton() {
        self.kakaoLoginButton.isEnabled = true
        self.appleLoginButton.isEnabled = true
    }
    
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(ScreenUtils.getHeight(282))
            $0.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(ScreenUtils.getHeight(17))
            $0.leading.trailing.equalToSuperview().inset(ScreenUtils.getWidth(91))
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-12)
            $0.trailing.leading.equalToSuperview().inset(38)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.equalTo(appleLoginButton.snp.leading)
            $0.trailing.equalTo(appleLoginButton.snp.trailing)
            $0.height.equalTo(appleLoginButton.snp.height)
            $0.bottom.equalTo(personalInformationButton.snp.top).offset(-8)
        }
        
        personalInformationButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(ScreenUtils.getHeight(6))
            $0.width.equalTo(ScreenUtils.getWidth(99))
            $0.centerX.equalTo(kakaoLoginButton)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(personalInformationButton.snp.bottom)
            $0.width.equalTo(ScreenUtils.getWidth(97))
            $0.centerX.equalTo(kakaoLoginButton)
            $0.height.equalTo(1)
        }
    }
    
    func setStyle() {
        self.view.backgroundColor = .white000
    }
    
    
    private func loginKakaoWithApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            guard error == nil else { 
                self.disableLoginButton()
                return }
            print("Login with KAKAO App Success !!")
            guard let oAuthToken = oAuthToken else { return }
            UserDefaults.standard.set(false, forKey: IsAppleLogined.isAppleLogin.rawValue)
            self.socialType = .kakao
            self.socialToken = oAuthToken.accessToken
        }
    }
    
    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            guard error == nil else {
                self.disableLoginButton()
                return }
            print("Login with KAKAO Web Success !!")
            guard let oAuthToken = oAuthToken else { return }
            UserDefaults.standard.set(false, forKey: IsAppleLogined.isAppleLogin.rawValue)
            self.socialType = .kakao
            self.socialToken = oAuthToken.accessToken
            
        }
    }
    
    @objc
    func kakaoLoginButtonTapped() {
        
        //카카오톡앱이 있으면 카카오앱으로 연결, 없으면 웹을 띄워줌
        if UserApi.isKakaoTalkLoginAvailable() {
            disableLoginButton()
            loginKakaoWithApp()
        } else {
            disableLoginButton()
            loginKakaoWithWeb()
        }
    }
    
    @objc
    func appleLoginButtonTapped() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
        
    }
    
    @objc
    func webViewButtonTapped() {
        let vc = PersonalInfoWebViewController()
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true)
    }
}

extension LoginViewController: ViewControllerServiceable {
    
    //추후에 에러코드에 따른 토스트 메세지 구현해야됨
    func handleError(_ error: NetworkError) {
            
        switch error {
        case .userState(let code, _):
            if code == "e4041" {
                let nextVC = MakeProfileViewController()
                nextVC.socialToken = self.socialToken
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        case .serverError:
            DOOToast.show(message: "서버 오류", insetFromBottom: ScreenUtils.getHeight(80))
        default:
            DOOToast.show(message: error.description, insetFromBottom: ScreenUtils.getHeight(80))
        }
        
        
        ableLoginButton()
//        switch error {
//        case .clientError(let message):
//            DOOToast.show(message: "\(message)", insetFromBottom: 80)
//        default:
//            DOOToast.show(message: error.description, insetFromBottom: 80)
//        }
    }
}
//애플로그인
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    //애플로그인 성공했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let userIdentifier = credential.identityToken else {
                //애플로그인 실패
                DOOToast.show(message: "애플로그인에 실패하셨습니다.", insetFromBottom: ScreenUtils.getHeight(80))
                return
            }
            
            //애플로그인 성공
            //애플로그인유저임을 인식
            UserDefaults.standard.set(true, forKey: IsAppleLogined.isAppleLogin.rawValue)
            self.socialType = .apple
            self.socialToken = String(data: userIdentifier, encoding: .utf8)
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



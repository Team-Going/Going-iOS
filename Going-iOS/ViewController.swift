//
//  ViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/21/23.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKUser
import SnapKit

final class ViewController: UIViewController {

    private lazy var kakaoLoginButton: UIButton = {
            let button = UIButton()
            button.setTitle("카카오로그인하기", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .yellow
            button.layer.cornerRadius = 25
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
            return button
        }()

        override func viewDidLoad() {
            super.viewDidLoad()
            setLayout()
        }

        private func setLayout() {
            view.addSubview(kakaoLoginButton)
            kakaoLoginButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }

        @objc func kakaoLoginButtonTapped() {
            if UserApi.isKakaoTalkLoginAvailable() {
                loginKakaoWithApp()
            } else {
                loginKakaoWithWeb()
            }
        }

        private func loginKakaoWithApp() {
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                guard error == nil else { return }
                print("Login with KAKAO App Success !!")
                guard let oAuthToken = oAuthToken else { return }
                print(oAuthToken.accessToken)
            }
        }

        private func loginKakaoWithWeb() {
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                guard error == nil else { return }
                print("Login with KAKAO Web Success !!")
                guard let oAuthToken = oAuthToken else { return }
                print(oAuthToken.accessToken)
            }
        }


}


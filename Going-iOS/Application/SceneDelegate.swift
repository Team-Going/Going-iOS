//
//  SceneDelegate.swift
//  32th-iOS-Seminar
//
//  Created by 김승찬 on 2023/01/14.
//

import UIKit

import AuthenticationServices
import KakaoSDKAuth
import Photos

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // 1.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // 2.
        self.window = UIWindow(windowScene: windowScene)
        // 3.
        let navigationController = UINavigationController(rootViewController: UserTestResultViewController())
        self.window?.rootViewController = navigationController
        navigationController.isNavigationBarHidden = true
        // 4.
        self.window?.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        //자동로그인
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "여기에 credential.user 넣기") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("authorized")
                //The Apple ID credential is valid.
                DispatchQueue.main.async {
                //authorized된 상태이므로 바로 로그인 완료 화면으로 이동
//                    self.window?.rootViewController = ViewController()
                }
            case .revoked:
                print("revoked")
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("notFound")
            default:
                break
            }
        }
    }
}

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
        let navigationController = UINavigationController(rootViewController: SplashViewController())
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
    }
}

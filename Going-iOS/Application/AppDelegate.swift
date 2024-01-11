//
//  AppDelegate.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/21/23.
//

import UIKit

import AuthenticationServices
import KakaoSDKCommon
import Photos

//PHPhotoLibraryChangeObserver
@main
class AppDelegate: UIResponder, UIApplicationDelegate, CheckPhotoAccessProtocol {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //앱이 처음 실행될 때, Access체크를 해서 UserDefault값을 변경해준다. 재실행해도 상관x
        checkAccess()
        
        let kakaoNativeAppKey = Config.kakaoNativeAppKey
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


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
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let kakaoNativeAppKey = Config.kakaoNativeAppKey
        KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "여기에 credential.user 넣기") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("authorized")
                // The Apple ID credential is valid.
                //                   DispatchQueue.main.async {
                //                     //authorized된 상태이므로 바로 로그인 완료 화면으로 이동
                //                     self.window?.rootViewController = ViewController()
                //                   }
            case .revoked:
                print("revoked")
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("")
                
            default:
                break
            }
        }
        
//        PHPhotoLibrary.shared().register(self)
        
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
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    //    func photoLibraryDidChange(_ changeInstance: PHChange) {
    //           // 사진 라이브러리 변경 사항 감지
    //           // 권한 변경 여부 확인 및 필요한 작업 수행
    //           if let details = changeInstance.changeDetails(for: PHAssetCollection.fetchTopLevelUserCollections(with: nil)) {
    //               // 권한 변경 여부 확인
    //               if details.hasIncrementalChanges {
    //                   // 변경이 감지되었을 때 필요한 작업 수행
    //                   print("Photo library permissions might have changed.")
    //               }
    //           }
    //       }
    
    
    
}


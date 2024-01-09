//
//  SplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import SnapKit

final class SplashViewController: UIViewController {
    
    private enum Size {
        static let logoHeight: CGFloat = 66 / 194
    }

    private let splashLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Splash.splashLogo
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        performActionBasedOnPermission()
    }

    
}

private extension SplashViewController {
     func setStyle() {
        self.view.backgroundColor = .red400
    }
    
     func setHierarchy() {
        view.addSubview(splashLogoImageView)
        
    }
    
    func setLayout() {
        
        splashLogoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.leading.equalToSuperview().inset(90)
            $0.height.equalTo(ScreenUtils.getHeight(66))
        }
    }
    
    func performActionBasedOnPermission() {
        if UserDefaults.standard.bool(forKey: "photoPermissionKey") {
            // 권한이 설정된 경우의 동작
            print("설정 가능")
            let nextVC = UserTestResultViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            // 권한이 거부된 경우의 동작
            print("설정 불가능")
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
//    @objc
//    func userDefaultsDidChange() {
//        let moveToUserTestResult = UserTestResultViewController()
//        self.navigationController?.pushViewController(moveToUserTestResult, animated: true)
//    }
}

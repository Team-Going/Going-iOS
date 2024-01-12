//
//  SplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import SnapKit

final class SplashViewController: UIViewController {
    
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

    override func viewWillAppear(_ animated: Bool) {
        checkUserStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pushActionBasedOnPermission()

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
    
    func pushActionBasedOnPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if UserDefaults.standard.bool(forKey: "photoPermissionKey") {
                // 권한이 설정된 경우의 동작
                print("설정 가능")

            } else {
                // 권한이 거부된 경우의 동작
                print("설정 불가능")

            }
        }
       
    }
}

extension SplashViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        
        //프로필생성뷰
        if error.description == "e4041" {
            let nextVC = MakeProfileViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
            //성향테스트스플래시뷰
        } else if error.description == "e4045" {
            let nextVC = UserTestSplashViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        }
    }
}

extension SplashViewController {
    func checkUserStatus() {

        guard UserDefaults.standard.string(forKey: UserDefaultToken.accessToken.rawValue) != nil else {
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            return
        }
        
        Task {
            do {
                try await SplashService.shared.getSplashInfo()
                let nextVC = DashBoardViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

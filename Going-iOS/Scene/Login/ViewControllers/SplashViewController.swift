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

    
    override func viewDidAppear(_ animated: Bool) {
        checkUserStatus()
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
            $0.trailing.leading.equalToSuperview().inset(ScreenUtils.getWidth(90))
            $0.height.equalTo(ScreenUtils.getHeight(66))
        }
    }
    
}

extension SplashViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .clientError(let message):
            DOOToast.show(message: "\(message)", insetFromBottom: ScreenUtils.getHeight(80))
        case .serverError:
            DOOToast.show(message: error.description, insetFromBottom: ScreenUtils.getHeight(80))
        case .unAuthorizedError:
            //로그인으로 보내기
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .reIssueJWT:
            DOOToast.show(message: "토큰이 만료되어서 다시 로그인해 주세요", insetFromBottom: ScreenUtils.getHeight(80))
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(let code, _):
            if code == "4041" {
                let nextVC = MakeProfileViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else if code == "e4045" {
                let nextVC = UserTestSplashViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
        default:
            DOOToast.show(message: error.description, insetFromBottom: ScreenUtils.getHeight(80))
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
                //
                try await OnBoardingService.shared.getSplashInfo()
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

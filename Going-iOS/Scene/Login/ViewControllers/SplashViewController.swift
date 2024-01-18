//
//  SplashViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

import SnapKit
import Lottie

final class SplashViewController: UIViewController {
    
    private let lottieView = LottieAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setStyle()
        setHierarchy()
        setLayout()
        setAnimation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if !NetworkCheck.shared.isConnected {
            DOOToast.show(message: "네트워크 상태를 확인해주세요", duration: 3 ,insetFromBottom: 100, completion: {
                exit(0)
            })
        }
    }
    
}

private extension SplashViewController {
    
    func setAnimation() {
        lottieView.animation = .named("dooripsplash3")
        lottieView.loopMode = .playOnce
        lottieView.play(completion: {completed in
            if completed {
                self.checkUserStatus()
            }
        })
    }
    func setStyle() {
        self.view.backgroundColor = .red400
    }
    
    func setHierarchy() {
        view.addSubview(lottieView)
        
    }
    
    func setLayout() {
        
        lottieView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        if UserDefaults.standard.string(forKey: UserDefaultToken.accessToken.rawValue) == nil {
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
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

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
        networkCheck()
    }
    
}

private extension SplashViewController {
    func networkCheck() {
        if !NetworkCheck.shared.isConnected {
            DOOToast.show(message: "네트워크 상태를 확인해주세요", duration: 3 ,insetFromBottom: 100, completion: {
                exit(0)
            })
        }
    }
    
    func setAnimation() {
        lottieView.contentMode = .scaleAspectFill
        lottieView.animation = .named("dooripsplash3")
        lottieView.loopMode = .playOnce
        lottieView.play(completion: {completed in
            if completed {
                self.checkUserStatus()
            }
        })
    }
    
    func setStyle() {
        self.view.backgroundColor = UIColor(resource: .gray400)
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

extension SplashViewController {
    
    func checkUserStatus() {
        if UserDefaults.standard.string(forKey: UserDefaultToken.accessToken.rawValue) == nil {
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = DashBoardViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}

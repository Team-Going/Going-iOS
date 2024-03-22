//
//  LogOutPopUpViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/10/24.
//

import UIKit

import SnapKit

final class LogOutPopUpViewController: PopUpDimmedViewController {
    
    // MARK: - UI Components
    
    private let popUpView = DOOPopUpContainerView()
    
    var logoutDismissCompletion: (() -> Void)?
    
    private let logOutLabel = DOOLabel(font: .pretendard(.body1_bold), color: UIColor(resource: .gray600), text: "정말 로그아웃하시겠어요?")
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(resource: .gray300), for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = UIColor(resource: .gray50)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(UIColor(resource: .white000), for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = UIColor(resource: .gray500)
        button.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setHierarchy()
        setLayout()
    }
}

// MARK: - Private Extension

private extension LogOutPopUpViewController {
    
    func setHierarchy() {
        view.addSubviews(dimmedView, popUpView)
        
        popUpView.addSubviews(logOutLabel,
                              backButton,
                              logOutButton)
    }
    
    func setLayout() {
        popUpView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(270))
            $0.height.equalTo(ScreenUtils.getHeight(114))
        }
        
        logOutLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.width.equalTo(ScreenUtils.getWidth(135))
            $0.leading.equalToSuperview()
        }
        
        logOutButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(44))
            $0.width.equalTo(ScreenUtils.getWidth(135))
            $0.trailing.equalToSuperview()
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func logOutButtonTapped() {
        postLogout()
    }
    
    @objc
    func backButtonTapped() {
        self.dismiss(animated: false)
    }
}

extension LogOutPopUpViewController: ViewControllerServiceable {
    
    func handleError(_ error: NetworkError) {
        switch error {
            
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
            print(error.description)
        }
    }
}

extension LogOutPopUpViewController {
    func postLogout() {
        Task {
            do {
                try await AuthService.shared.patchLogout()
                UserDefaults.standard.removeObject(forKey: UserDefaultToken.accessToken.rawValue)
                UserDefaults.standard.removeObject(forKey: UserDefaultToken.refreshToken.rawValue)
//                UserDefaults.standard.set(true, forKey: "isFromMakeProfileVC")
                
                guard let logoutDismissCompletion else {return}
                self.dismiss(animated: false) {
                    logoutDismissCompletion()
                }
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
    
    func reIssueJWTToken() {
        Task {
            do {
                try await AuthService.shared.postReIssueJWTToken()
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

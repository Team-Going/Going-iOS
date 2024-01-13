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
    
    private let logOutLabel = DOOLabel(font: .pretendard(.body1_bold), color: .gray600, text: "정말 로그아웃하시겠어요?")
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = .gray50
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white000, for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_bold)
        button.backgroundColor = .gray500
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
        view.addSubview(popUpView)
        popUpView.addSubviews(logOutLabel, backButton, logOutButton)
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
        print("로그아웃 서버 통신")
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
        case .reIssueJWT:
            //JWT재발급API 후에 다시 통신
            print("")
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
                let nextVC = LoginViewController()
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

//
//  MyProfileViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/11/24.
//

import UIKit

import SnapKit
import Photos

final class MyProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var testResultData: UserTypeTestResultAppData? {
        didSet {
            guard let data = testResultData else { return }
            self.myProfileTopView.profileImageView.image = data.profileImage
            self.resultImageView.image = data.typeImage
            self.myResultView.resultViewData = data
        }
    }
    
    private var testResultIndex: Int?
    
    // MARK: - UI Properties
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("내 여행 프로필"))
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(resource: .btnSave), for: .normal)
        btn.addTarget(self, action: #selector(saveImageButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let naviUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray100)
        return view
    }()
    
    private let myProfileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let myProfileTopView = MyProfileTopView()
    
    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(resource: .white000)
        return imageView
    }()
        
    private let myResultView: TestResultView = {
        let view = TestResultView()
        view.nameLabel.isHidden = true
        view.userTypeLabel.font = .pretendard(.body1_bold)
        view.userTypeLabel.textColor = UIColor(resource: .gray700)
        view.typeDescLabel.font = .pretendard(.detail3_regular)
        view.typeDescLabel.textColor = UIColor(resource: .gray300)
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        hideTabbar()
        getUserProfile()
    }
}

// MARK: - Private Methods

private extension MyProfileViewController {
    func hideTabbar() {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    func setDelegate() {
        myResultView.delegate = self
        myProfileTopView.delegate = self
    }
    
    func setStyle() {
        contentView.backgroundColor = UIColor(resource: .white000)
        view.backgroundColor = UIColor(resource: .white000)
        self.myProfileScrollView.showsVerticalScrollIndicator = false
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, 
                         naviUnderLineView, 
                         myProfileScrollView)
        
        navigationBar.addSubview(saveButton)
        
        myProfileScrollView.addSubviews(contentView)
        
        contentView.addSubviews(myProfileTopView, 
                                resultImageView,
                                myResultView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        saveButton.snp.makeConstraints {
            $0.centerY.equalTo(navigationBar)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        naviUnderLineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        myProfileScrollView.snp.makeConstraints {
            $0.top.equalTo(naviUnderLineView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(myProfileScrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }

        myProfileTopView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(109))
        }
        
        resultImageView.snp.makeConstraints {
            $0.top.equalTo(myProfileTopView.snp.bottom)
            $0.height.equalTo(228)
            $0.width.equalTo(Constant.Screen.width)
        }
        
        myResultView.snp.makeConstraints {
            $0.top.equalTo(resultImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func saveImage() {
        guard let saveImage = testResultData?.phoneSaveImage else {
            DOOToast.show(message: "이미지 저장 오류", insetFromBottom: 80)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil)
        DOOToast.show(message: "이미지로 저장되었어요\n친구에게 내 캐릭터를 공유해보세요", insetFromBottom: 114)
    }
    
    func showPermissionAlert() {
        // PHPhotoLibrary.requestAuthorization() 결과 콜백이 main thread로부터 호출되지 않기 때문에
        // UI처리를 위해 main thread내에서 팝업을 띄우도록 함.
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: "설정으로 이동하여 권한을 허용해 주세요. 내 여행 프로필에서 다시 저장할 수 있어요.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - @objc methods
    
    @objc
    func saveImageButtonTapped() {
        checkAccess()
    }
}

extension MyProfileViewController: CheckPhotoAccessProtocol {
    func checkAccess() {
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
            
        case .notDetermined, .denied:
            UserDefaults.standard.set(false, forKey: "photoPermissionKey")
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
                switch status {
                case .authorized, .limited:
                    UserDefaults.standard.set(true, forKey: "photoPermissionKey")
                case .denied:
                    DispatchQueue.main.async {
                        self?.showPermissionAlert()
                    }
                default:
                    print("그 밖의 권한이 부여 되었습니다.")
                }
                
            }
        case .restricted, .limited, .authorized:
            saveImage()
            UserDefaults.standard.set(true, forKey: "photoPermissionKey")
        @unknown default:
            print("unKnown")
        }
    }
}

extension MyProfileViewController {
    func getUserProfile() {
        Task {
            do {
                let profileData = try await TravelService.shared.getProfileInfo()
                self.testResultIndex = profileData.result
                self.myProfileTopView.userDescriptionLabel.text = profileData.intro
                self.myProfileTopView.userNameLabel.text = profileData.name
                
                guard let index = testResultIndex else { return }
                self.testResultData = UserTypeTestResultAppData.dummy()[index]
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

extension MyProfileViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .unAuthorizedError, .reIssueJWT:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(_, let message):
            DOOToast.show(message: message, insetFromBottom: 80)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
}

extension MyProfileViewController {
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

extension MyProfileViewController: TestResultViewDelegate {
    func backToTestButton() {
        let nextVC = UserTestSplashViewController()
        UserDefaults.standard.set(false, forKey: "isFromMakeProfileVC")
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}

extension MyProfileViewController: MyProfileTopViewDelegate {
    func changeMyProfileButtonTapped() {
        let nextVC = ChangeMyProfileViewController()
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
}

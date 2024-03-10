//
//  MyTravelProfileViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/3/24.
//


import UIKit

import Photos
import SnapKit

final class MyTravelProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var segmentIndex: Int = 0
    
    private var testResultData: UserTypeTestResultAppData? {
        didSet {
            guard let data = testResultData else { return }
            self.myProfileTopView.profileImageView.image = data.profileImage
            self.userTestResultScrollView.resultImageView.image = data.typeImage
            self.userTestResultScrollView.myResultView.resultViewData = data
        }
    }
    
    private var testResultIndex: Int?
    
    lazy var participantId: Int = 0
    
    var isOwner: Bool = false
    
    var isEmpty: Bool = false
        
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
    
    private let myProfileTopView = MyProfileTopView()
    
    private let travelProfileHeaderView = TravelProfileHeaderView()
    
    private let emptyUserTestView = EmptyUserTestView()
    
    private let userTestResultScrollView = UserTestResultScrollView()
    
    private let travelTestResultView = TravelTestResultView()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setOwnerOption()
        setHierarchy()
        setLayout()
        setDelegate()
        setSegmentDidChange()
        setSegment()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getPersonalProfile(participantId: participantId)
        hideTabBar()
    }
}

// MARK: - Private Methods

private extension MyTravelProfileViewController {
    
    func hideTabBar() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setStyle() {
        view.backgroundColor = UIColor(resource: .white000)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         naviUnderLineView,
                         myProfileTopView,
                         travelProfileHeaderView,
                         emptyUserTestView,
                         userTestResultScrollView,
                         travelTestResultView)
        
        navigationBar.addSubview(saveButton)
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
        
        myProfileTopView.snp.makeConstraints {
            $0.top.equalTo(naviUnderLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(109))
        }
        
        travelProfileHeaderView.snp.makeConstraints {
            $0.top.equalTo(myProfileTopView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        emptyUserTestView.snp.makeConstraints {
            $0.top.equalTo(travelProfileHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
        }
        
        userTestResultScrollView.snp.makeConstraints {
            $0.top.equalTo(travelProfileHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        travelTestResultView.snp.makeConstraints {
            $0.top.equalTo(travelProfileHeaderView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    func setDelegate() {
        userTestResultScrollView.myResultView.delegate = self
        travelTestResultView.delegate = self
    }
    
    func setSegmentDidChange() {
        self.didChangeValue(sender: self.travelProfileHeaderView.segmentedControl)
    }
    
    func setSegment() {
        travelProfileHeaderView.segmentedControl.addTarget(self,
                                                       action: #selector(didChangeValue(sender:)),
                                                       for: .valueChanged)
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
    
    func setOwnerOption() {
        if isOwner {
            navigationBar.titleLabel.text = StringLiterals.MyProfile.myProfileTitle
            saveButton.isHidden = false
            myProfileTopView.editProfileButton.isHidden = false
            userTestResultScrollView.myResultView.backToTestButton.isHidden = false
            travelTestResultView.retryTravelTestButton.isHidden = false
        } else {
            navigationBar.titleLabel.text = StringLiterals.MyProfile.friendProfileTitle
            saveButton.isHidden = true
            myProfileTopView.editProfileButton.isHidden = true
            userTestResultScrollView.myResultView.backToTestButton.isHidden = true
            travelTestResultView.retryTravelTestButton.isHidden = true
        }
    }
    
    func setEmptyView() {
        if isEmpty {
            userTestResultScrollView.isHidden = true
            emptyUserTestView.isHidden = false
        } else {
            userTestResultScrollView.isHidden = false
            emptyUserTestView.isHidden = true
        }
    }
    
    // MARK: - @objc methods
    
    @objc func saveImageButtonTapped() {
        checkAccess()
    }
    
    @objc
    func didChangeValue(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.segmentIndex = 0
            userTestResultScrollView.isHidden = false
            travelTestResultView.isHidden = true
            setEmptyView()
        } else {
            self.segmentIndex = 1
            emptyUserTestView.isHidden = true
            userTestResultScrollView.isHidden = true
            travelTestResultView.isHidden = false
        }
    }
}

// MARK: - Save Images

extension MyTravelProfileViewController: CheckPhotoAccessProtocol {
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

// MARK: Delegates

extension MyTravelProfileViewController: TestResultViewDelegate {
    func backToTestButton() {
        let vc = UserTestSplashViewController()
        self.navigationController?.pushViewController(vc, animated: false)
        vc.beforeVC = "myProfile"
    }
}

extension MyTravelProfileViewController: RetryTestResultViewDelegate {
    func retryTravelTestButton() {
        let vc = TravelTestViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: - Network

extension MyTravelProfileViewController {
    
    func getPersonalProfile(participantId: Int) {
        Task {
            do {
                let profileData = try await MemberService.shared.getPersonalProfile(participantId: participantId)
                self.testResultIndex = profileData.result
                self.myProfileTopView.userDescriptionLabel.text = profileData.intro
                self.myProfileTopView.userNameLabel.text = profileData.name
                self.travelTestResultView.beforVC = "MyTravelProfile"
                self.travelTestResultView.participantId = participantId
                self.travelTestResultView.styleResult = [profileData.styleA,
                                                         profileData.styleB,
                                                         profileData.styleC,
                                                         profileData.styleD,
                                                         profileData.styleE]
                
                guard let index = testResultIndex else { return }
                if index != -1 {
                    self.testResultData = UserTypeTestResultAppData.dummy()[index]
                    self.isEmpty = false
                } else {
                    self.isEmpty = true
                    setEmptyView()
                }
            }
            catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

extension MyTravelProfileViewController: ViewControllerServiceable {
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

extension MyTravelProfileViewController {
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

//
//  UserTestResultViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit
import Photos

final class UserTestResultViewController: UIViewController {
    
    private var testResultData: UserTypeTestResultAppData? {
        didSet {
            guard let data = testResultData else { return }
            self.resultImageView.image = data.typeImage
            self.resultView.resultViewData = data
        }
    }
    
    private var testResultIndex: Int?
    
    private lazy var navigationBar = DOONavigationBar(self, type: .titleLabelOnly("나의 여행 캐릭터"))
    
    private let naviUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let testResultScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageLiterals.UserTestTypeCharacter.aeiCharac
        imageView.backgroundColor = .white000
        return imageView
    }()
    
    private let resultView = TestResultView()
    
    private let gradientView =  UIView()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray500
        button.setTitle("doorip 시작하기", for: .normal)
        button.setTitleColor(.white000, for: .normal)
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveImageButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.NavigationBar.buttonSave, for: .normal)
        button.addTarget(self, action: #selector(saveImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProfileInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
    }
}

private extension UserTestResultViewController {
    
    func setDelegate() {
        resultView.delegate = self
    }
    
    func setGradient() {
        gradientView.setGradient(firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), axis: .vertical)
    }
    
    func setStyle() {
        contentView.backgroundColor = .black000
        view.backgroundColor = .white000
        resultView.backgroundColor = .white
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, naviUnderLineView, testResultScrollView, nextButton, gradientView)
        navigationBar.addSubview(saveImageButton)
        testResultScrollView.addSubviews(contentView)
        contentView.addSubviews(resultImageView, resultView)
    }
    
    func setLayout() {
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        saveImageButton.snp.makeConstraints {
            $0.width.height.equalTo(ScreenUtils.getWidth(48))
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        naviUnderLineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        testResultScrollView.snp.makeConstraints {
            $0.top.equalTo(naviUnderLineView.snp.bottom)
            $0.bottom.equalTo(nextButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(40))
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(testResultScrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        resultImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(228)
            $0.width.equalTo(Constant.Screen.width)
        }
        
        resultView.snp.makeConstraints {
            $0.top.equalTo(resultImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    @objc
    func saveImageButtonTapped() {
        checkAccess()
    }
    
    func saveImage() {
        UIImageWriteToSavedPhotosAlbum(resultImageView.image!, self, nil, nil)
        DOOToast.show(message: "이미지가 저장되었습니다. \n친구에게 내 캐릭터를 공유해보세요", insetFromBottom: 114)
    }
    
    @objc
    func nextButtonTapped() {
        let nextVC = DashBoardViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showPermissionAlert() {
        // PHPhotoLibrary.requestAuthorization() 결과 콜백이 main thread로부터 호출되지 않기 때문에
        // UI처리를 위해 main thread내에서 팝업을 띄우도록 함.
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: "설정으로 이동하여 권한을 허용해주세요. 내 여행 프로필에서 다시 저장할 수 있어요.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default, handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            
        }
    }
}

extension UserTestResultViewController: CheckPhotoAccessProtocol {
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

extension UserTestResultViewController {
    func getProfileInfo() {
        Task {
            do {
                let profileData = try await TravelService.shared.getProfileInfo()
                self.testResultIndex = profileData.result
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

extension UserTestResultViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .reIssueJWT:
            print("재발급")
        case .serverError:
            DOOToast.show(message: "서버오류", insetFromBottom: 80)
        case .unAuthorizedError:
            DOOToast.show(message: "토큰만료, 재로그인필요", insetFromBottom: 80)
            let nextVC = LoginViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        case .userState(let code, let message):
            DOOToast.show(message: "\(code) : \(message)", insetFromBottom: 80)
        default:
            DOOToast.show(message: error.description, insetFromBottom: 80)
        }
    }
}

extension UserTestResultViewController: TestResultViewDelegate {
    func backToTestButton() {
        let nextVC = UserTestSplashViewController()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}




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
    
    private lazy var navigationBar = DOONavigationBar(self, type: .titleLabelOnly("유형 검사 결과"))
    
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
        imageView.image = UIImage(systemName: "pencil")
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    private let resultView = TestResultView()
    
    private let gradientView =  UIView()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray500
        button.setTitle("완성된 프로필", for: .normal)
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white000
        button.setTitle("이미지로 저장", for: .normal)
        button.setTitleColor(.gray600, for: .normal)
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray300.cgColor
        button.addTarget(self, action: #selector(saveImageButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setGradient()
    }
}

private extension UserTestResultViewController {
    
    func setGradient() {
        gradientView.setGradient(firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), axis: .vertical)
    }
    
    func setStyle() {
        contentView.backgroundColor = .black000
        view.backgroundColor = .white000
        resultView.backgroundColor = .white
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, naviUnderLineView, testResultScrollView, nextButton, saveImageButton, gradientView)
        testResultScrollView.addSubviews(contentView)
        contentView.addSubviews(resultImageView, resultView)
    }
    
    func setLayout() {
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
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
        
        saveImageButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(160))
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(saveImageButton.snp.bottom)
            $0.leading.equalTo(saveImageButton.snp.trailing).offset(7)
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(160))
            
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
        UIImageWriteToSavedPhotosAlbum(UIImage(systemName: "pencil")!, self, nil, nil)
        DOOToast.show(message: "이미지가 저장되었습니다.", insetFromBottom: 114)
    }
    
    @objc
    func nextButtonTapped() {
//        let nextVC = CompleteProfileViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showPermissionAlert() {
        // PHPhotoLibrary.requestAuthorization() 결과 콜백이 main thread로부터 호출되지 않기 때문에
        // UI처리를 위해 main thread내에서 팝업을 띄우도록 함.
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: "사진 접근 권한이 없습니다. 설정으로 이동하여 권한 설정을 해주세요.", preferredStyle: .alert)
            
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
                    print("권한설정됐다는 토스트? 띄우면 좋을듯")
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




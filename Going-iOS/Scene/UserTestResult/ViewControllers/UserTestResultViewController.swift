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
        contentView.backgroundColor = .black
        view.backgroundColor = .white000
        resultView.backgroundColor = .white
    }
    
    func setHierarchy() {
        view.addSubviews(testResultScrollView, nextButton, saveImageButton, gradientView)
        testResultScrollView.addSubviews(contentView)
        contentView.addSubviews(resultImageView, resultView)
    }
    
    func setLayout() {
        
        testResultScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        //        let image = resultImageView.convertUIImage()
        //        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
        
        switch PHPhotoLibrary.authorizationStatus(for: .addOnly) {
        case .notDetermined:
            print("not determined")
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] status in
                switch status {
                case .authorized, .limited:
                    print("권한이 부여 됬습니다. 앨범 사용이 가능합니다")
                case .denied:
                    print("권한이 거부 됬습니다. 앨범 사용 불가합니다.")
                    DispatchQueue.main.async {
//                        self!.moveToSetting()
                        self?.showPermissionAlert()
                    }
                default:
                    print("그 밖의 권한이 부여 되었습니다.")
                }
            }
        case .restricted:
            print("restricted")
        case .denied:
            print("denined")
            DispatchQueue.main.async {
//                self.moveToSetting()
                self.showPermissionAlert()
            }
        case .authorized:
            print("autorized")
        case .limited:
            print("limited")
        @unknown default:
            print("unKnown")
        }
        
        
        
        //        추후에 기획단에서 주는 이미지로 변경(resultImageView가 저장되는 것이 아니라, 결과값에 따른 다른 이미지가 저장됨
        //        배열에 미리 넣어두고 결과값에 따라 뿌려준다.
        
    }
    
    @objc
    func nextButtonTapped() {
        let nextVC = CompleteProfileViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func showPermissionAlert() {
        // PHPhotoLibrary.requestAuthorization() 결과 콜백이 main thread로부터 호출되지 않기 때문에
        // UI처리를 위해 main thread내에서 팝업을 띄우도록 함.
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "사진 접근 권한이 없습니다. 설정으로 이동하여 권한 설정을 해주세요.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                print("확인 누름")
            }))
            
            self.present(alert, animated: true)
        }
    }
}




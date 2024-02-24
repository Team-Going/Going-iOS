//
//  SettingsViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/8/24.
//

import UIKit

import SnapKit

final class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let settingsItem: [SettingsItem] = SettingsItem.settingsDummy
    
    // MARK: - UI Properties

    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("설정"))
    
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private lazy var deleteUserButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("회원탈퇴", for: .normal)
        btn.titleLabel?.font = .pretendard(.detail2_regular)
        btn.setTitleColor(.gray300, for: .normal)
        btn.setImage(UIImage(resource: .icUnsubscribe), for: .normal)
        btn.addTarget(self, action: #selector(deleteUserButtonTapped), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
    }()
    
    private let deleteButtonUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private let settingsCollectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .gray50
        view.isScrollEnabled = false
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        setDelegate()
        registerCell()
    }
}

private extension SettingsViewController {
    func setStyle() {
        self.view.backgroundColor = .white000
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        self.view.addSubviews(settingsCollectionView,
                              navigationBar,
                              navigationUnderlineView,
                              deleteUserButton,
                              deleteButtonUnderLine)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        navigationUnderlineView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        settingsCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        deleteUserButton.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(60))
            $0.height.equalTo(ScreenUtils.getHeight(20))
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
        }
        
        deleteButtonUnderLine.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(60))
            $0.height.equalTo(ScreenUtils.getHeight(0.5))
            $0.top.equalTo(deleteUserButton.snp.bottom)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    func setDelegate() {
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
    }
    
    func registerCell() {
        settingsCollectionView.register(SettingsCollectionViewCell.self, 
                                        forCellWithReuseIdentifier: SettingsCollectionViewCell.cellIdentifier)
    }
    
    // MARK: - @objc Methods
    
    @objc
    func deleteUserButtonTapped() {
        let deleteVC = DeleteUserPopUpViewController()
        deleteVC.deleteUserDismissCompletion = { [weak self] in
            guard let self else {return}
            self.navigationController?.pushViewController(LoginViewController(), animated: false)
        }
        self.navigationController?.present(deleteVC, animated: false)
    }
}


extension SettingsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = settingsCollectionView.dequeueReusableCell(withReuseIdentifier: SettingsCollectionViewCell.cellIdentifier, for: indexPath) as? SettingsCollectionViewCell else { return UICollectionViewCell() }
        cell.settingsData = settingsItem[indexPath.row]
        return cell
    }
}

extension SettingsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = settingsItem[indexPath.row]
        
        switch item.title {
        case "여행 프로필":
            let profileVC = MyProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        case "문의하기":
            let inquiryVC = WebViewController(urlString: "https://www.notion.so/goinggoing/FAQ-920f6ad93fea46a983061f412e15cad1?pvs=4")
            self.present(inquiryVC, animated: true)
        case "서비스이용약관":
            let policyVC = WebViewController(urlString: "https://www.notion.so/goinggoing/c4d5513bba2c4c20aaf9e21522289304?pvs=4")
            self.present(policyVC, animated: true)
        case "개인정보처리방침":
            let privacyVC = WebViewController(urlString: "https://www.notion.so/goinggoing/doorip-75f5d981a5b842a6be74a9dc17ca67de?pvs=4")
            self.present(privacyVC, animated: true)
        case "About doorip":
            let aboutServiceVC = WebViewController(urlString: "https://www.notion.so/goinggoing/About-doorip-758273e2bebb477aac0adb0195359f21?pvs=4")
            self.present(aboutServiceVC, animated: true)
        case "로그아웃":
            let logOutVC = LogOutPopUpViewController()
            logOutVC.logoutDismissCompletion = { [weak self] in
                guard let self else {return}
                self.navigationController?.pushViewController(LoginViewController(), animated: false)
            }
            self.navigationController?.present(logOutVC, animated: false)
        default:
            break
        }
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    /// minimun item spacing
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    /// cell size
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ScreenUtils.getWidth(327)
        let height = ScreenUtils.getHeight(50)
        return CGSize(width: width, height: height)
    }
    
    /// content margin
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 24, bottom: 338, right: 24)
    }
}

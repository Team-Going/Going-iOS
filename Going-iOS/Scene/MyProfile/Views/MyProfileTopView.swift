//
//  MyProfileTopView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/2/24.
//

import UIKit

import SnapKit

protocol MyProfileTopViewDelegate: AnyObject {
    func changeMyProfileButtonTapped()
}

final class MyProfileTopView: UIView {
    
    weak var delegate: MyProfileTopViewDelegate?
    
    // MARK: - UI Properties
    
    let profileImageView: UIImageView = {
        let img = UIImageView()
        img.layer.cornerRadius = 28
        img.clipsToBounds = true
        img.layer.borderWidth = 0.5
        img.layer.borderColor = UIColor(resource: .gray100).cgColor
        return img
    }()
    
    let userNameLabel = DOOLabel(font: .pretendard(.body1_bold), color: UIColor(resource: .gray500))
    
    let userDescriptionLabel = DOOLabel(font: .pretendard(.detail1_regular), color: UIColor(resource: .gray500))
    
    lazy var editProfileButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("프로필 수정", for: .normal)
        btn.setTitleColor(UIColor(resource: .gray400), for: .normal)
        btn.titleLabel?.font = .pretendard(.detail1_regular)
        btn.backgroundColor = UIColor(resource: .gray50)
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 0.4
        btn.layer.borderColor = UIColor(resource: .gray100).cgColor
        btn.addTarget(self, action: #selector(editProfileButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private let grayDividingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .gray50)
        return view
    }()
    
    var userType: Int? {
        didSet {
            guard let userType else { return }
            if userType != -1 {
                profileImageView.image = userProfileImageSet[userType]
            } else {
                profileImageView.image =  UIImage(resource: .imgProfileGuest)
            }
        }
    }
    
    let userProfileImageSet: [UIImage] = [UIImage(resource: .imgProfileSrp),
                                          UIImage(resource: .imgProfileSri),
                                          UIImage(resource: .imgProfileSep),
                                          UIImage(resource: .imgProfileSei),
                                          UIImage(resource: .imgProfileArp),
                                          UIImage(resource: .imgProfileAri),
                                          UIImage(resource: .imgProfileAep),
                                          UIImage(resource: .imgProfileAei)]
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension MyProfileTopView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        addSubviews(profileImageView,
                    userNameLabel,
                    userDescriptionLabel,
                    editProfileButton,
                    grayDividingView)
    }
    
    func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(23)
            $0.size.equalTo(ScreenUtils.getHeight(56))
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(29)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        userDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(userNameLabel)
        }
        
        editProfileButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.trailing.equalToSuperview().inset(24)
            $0.width.equalTo(ScreenUtils.getWidth(73))
            $0.height.equalTo(ScreenUtils.getHeight(24))
        }
        
        grayDividingView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(22)
            $0.width.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(8))
        }
    }
    
    // MARK: - @objc methods
    
    @objc
    func editProfileButtonTapped() {
        delegate?.changeMyProfileButtonTapped()
    }
}

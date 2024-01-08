//
//  CompleteProfileViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/7/24.
//

import UIKit

import SnapKit

final class CompleteProfileViewController: UIViewController {
    
    private let completeProfileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let userProfileBackgroundView = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "pencil")
        return imageView
    }()
    
    private let userNameLabel = DOOLabel(font: .pretendard(.head2), color: .gray600, text: "곽두릅")
    private let userDescLabel = DOOLabel(font: .pretendard(.detail1_regular), color: .gray300, text: "곽곽곽곽곽")
    
    private let userTypeTestResultView = TestResultView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()

    }
}

private extension CompleteProfileViewController {
    
    func setHierarchy() {
        view.addSubview(completeProfileScrollView)
        completeProfileScrollView.addSubviews(contentView)
        contentView.addSubviews(userProfileBackgroundView, userTypeTestResultView)
        userProfileBackgroundView.addSubviews(profileImageView, userNameLabel, userDescLabel)
    }
    
    func setLayout() {
        
        completeProfileScrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(completeProfileScrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        userProfileBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(247))
            
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(132)
            $0.height.equalTo(ScreenUtils.getHeight(110))
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.centerX.equalTo(profileImageView)
        }
        
        userDescLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(userNameLabel)
        }
        
        userTypeTestResultView.snp.makeConstraints {
            $0.top.equalTo(userProfileBackgroundView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    func setStyle() {
        userProfileBackgroundView.backgroundColor = .gray50
        contentView.backgroundColor = .gray50
        profileImageView.backgroundColor = .gray200
        view.backgroundColor = .white000
        
    }

}

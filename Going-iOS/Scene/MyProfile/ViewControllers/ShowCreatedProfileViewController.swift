//
//  ShowCreatedProfileViewController.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/11/24.
//

import UIKit

import SnapKit
import Photos

final class ShowCreatedProfileViewController: UIViewController {
    
    private lazy var navigationBar = DOONavigationBar(self, type: .backButtonWithTitle("프로필 생성"))
    
    private let naviUnderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let navigationUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let profileScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "pencil")
        imageView.backgroundColor = .orange
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private let nickNameLabel = DOOLabel(font: .pretendard(.head2), color: .gray600, text: "찐두릅")
    private let descriptionLabel = DOOLabel(font: .pretendard(.detail1_regular), color: .gray300, text: "우리 짱이다")
    
    private let myResultView = MyResultView()
    
    private let gradientView = UIView()
    private lazy var startButton: DOOButton = {
        let btn = DOOButton(type: .enabled, title: "시작하기")
        btn.addTarget(self, action: #selector(pushToStartTravelSplashVC), for: .touchUpInside)
        return btn
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

private extension ShowCreatedProfileViewController {
    func setStyle() {
        contentView.backgroundColor = .gray50
        view.backgroundColor = .white000
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar,
                         naviUnderLineView,
                         profileScrollView,
                         gradientView,
                         startButton)
        profileScrollView.addSubviews(contentView)
        contentView.addSubviews(profileImageView,
                                nickNameLabel,
                                descriptionLabel,
                                myResultView)
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
        
        profileScrollView.snp.makeConstraints {
            $0.top.equalTo(naviUnderLineView.snp.bottom)
            $0.bottom.equalTo(startButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(profileScrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(view.snp.height).priority(.low)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(ScreenUtils.getWidth(110))
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(4)
        }
        
        myResultView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(contentView.snp.bottom)
        }
        
        startButton.snp.makeConstraints {
            $0.height.equalTo(ScreenUtils.getHeight(50))
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-6)
            $0.centerX.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(startButton.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(40))
        }
    }
    
    func setGradient() {
        gradientView.setGradient(firstColor: UIColor(red: 1, green: 1, blue: 1, alpha: 0), secondColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), axis: .vertical)
    }
    
    // MARK: - @objc Methods
    
    @objc
    func pushToStartTravelSplashVC() {
        let vc = StartTravelSplashViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

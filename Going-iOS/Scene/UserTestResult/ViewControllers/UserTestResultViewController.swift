//
//  UserTestResultViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class UserTestResultViewController: UIViewController {
    
    private let testResultScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemOrange
        return imageView
    }()
    
    private let resultView = TestResultView()
    
    private let gradientView =  UIView()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray500
        button.setTitle("완성된 프로필", for: .normal)
        button.titleLabel?.font = .pretendard(.body1_bold)
        return button
    }()
    
    private lazy var backToTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 해볼래요", for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(.gray300, for: .normal)
        button.setUnderline()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        resultView.backgroundColor = .white
        
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
        contentView.backgroundColor = .blue
        view.backgroundColor = .white000
    }
    
    func setHierarchy() {
        view.addSubviews(testResultScrollView, nextButton, backToTestButton, gradientView)
        testResultScrollView.addSubviews(contentView)
        contentView.addSubviews(resultImageView, resultView)
    }
    
    func setLayout() {
        
        testResultScrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(nextButton.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        backToTestButton.snp.makeConstraints {
            $0.top.equalTo(nextButton.snp.bottom).offset(9)
            $0.centerX.equalTo(nextButton)
        }
        
        gradientView.snp.makeConstraints {
            $0.bottom.equalTo(nextButton.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(testResultScrollView.contentLayoutGuide)
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
            $0.bottom.equalToSuperview()
        }
        
    }
}

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
        scrollView.backgroundColor = .red
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
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setHierarchy()
        setLayout()
        resultView.backgroundColor = .white
        
    }
}

private extension UserTestResultViewController {
    func setStyle() {
        contentView.backgroundColor = .blue
    }
    
    func setHierarchy() {
        view.addSubviews(testResultScrollView)
        testResultScrollView.addSubviews(contentView)
        contentView.addSubviews(resultImageView, resultView)
    }
    
    func setLayout() {
        
        testResultScrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
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

//
//  UserTestViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class UserTestViewController: UIViewController {
    
    private let testProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .red500
        progress.setProgress(0.1111111, animated: true)
        return progress
    }()
    
    private let testIndexLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .gray300
        label.textColor = .darkGray
        label.text = " ㅇㅇ"
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head3)
        label.textColor = .gray700
        label.text = " ㅇㅇ"
        return label
    }()
    
    private let questionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private lazy var firstButton: UIButton = makeButton()
    private lazy var secondButton: UIButton = makeButton()
    private lazy var thirdButton: UIButton = makeButton()
    private lazy var fourthButton: UIButton = makeButton()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
//        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.backgroundColor = .gray200
        button.isEnabled = false
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.titleLabel?.textColor = .gray200
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setHierarchy()
        setLayout()
        setStyle()
    }

}

private extension UserTestViewController {
    
    func makeButton() -> UIButton {
        let button = UIButton()
        //        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .gray50
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .pretendard(.body3_medi)
        button.titleLabel?.textColor = .gray500
        return button
    }
    
    func setHierarchy() {
        view.addSubviews(testProgressView, testIndexLabel, questionLabel, questionStackView, nextButton)
        self.questionStackView.addArrangedSubviews(firstButton, secondButton, thirdButton, fourthButton)
    }
    
    func setLayout() {
        testProgressView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(8))
        }
        
        testIndexLabel.snp.makeConstraints {
            $0.top.equalTo(testProgressView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(testIndexLabel.snp.bottom)
            $0.leading.equalTo(testIndexLabel.snp.leading)
        }
        
        questionStackView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        firstButton.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(327))
            $0.height.equalTo(ScreenUtils.getHeight(60))
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(ScreenUtils.getHeight(50))
        }
        
        
    }
    
    func setStyle() {
        view.backgroundColor = .white000
    }
    
}

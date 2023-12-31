//
//  UserTestViewController.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class UserTestViewController: UIViewController {
    
    private var buttonIndexList: [Int] = []
    
    private var index: Int = 0
    
    private var buttonIndex: Int = 0
    
    private let userTestDataStruct = UserTestQuestionStruct.dummy()
    
    private var selectedButton: UIButton?
    
    private let testProgressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .red500
        progress.setProgress(0.1111111, animated: true)
        return progress
    }()
    
    private let testIndexLabel = DOOLabel(font: .pretendard(.head3), color: .gray300)
    private let questionLabel = DOOLabel(font: .pretendard(.head3), color: .gray700)
    
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
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.backgroundColor = .gray200
        button.isEnabled = false
        button.titleLabel?.font = .pretendard(.body1_bold)
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
        updateNextButtonState()
        updateLabel()
        
    }
}

private extension UserTestViewController {
    
    func makeButton() -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .gray50
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .pretendard(.body3_medi)
        button.setTitleColor(UIColor.gray500, for: .normal)
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

private extension UserTestViewController {
    
    func updateLabel() {
        
        testIndexLabel.text = "\(userTestDataStruct[index].testIndex) / 9"
        questionLabel.text = "\(userTestDataStruct[index].testTitle)"
        
        firstButton.setTitle("\(userTestDataStruct[index].testText.firstQuest)", for: .normal)
        secondButton.setTitle("\(userTestDataStruct[index].testText.secondQuest)", for: .normal)
        thirdButton.setTitle("\(userTestDataStruct[index].testText.thirdQuest)", for: .normal)
        fourthButton.setTitle("\(userTestDataStruct[index].testText.fourthQuest)", for: .normal)
    }
    
    func updateNextButtonState() {
        // 선택된 버튼이 있는지 확인하고 nextButton의 활성화 여부를 결정
        nextButton.isEnabled = selectedButton == nil ? false : true
        nextButton.backgroundColor = nextButton.isEnabled ? .gray500 : .gray50

        if nextButton.isEnabled {
            nextButton.setTitleColor(.white000, for: .normal)
        } else {
            nextButton.setTitleColor(.gray200, for: .normal)
        }
    }
    
    func resetButtons() {
        // 다른 버튼들의 색상을 클릭하지 않은 상태로 초기화
        for case let button as UIButton in questionStackView.arrangedSubviews {
            button.backgroundColor = .gray50
            button.setTitleColor(UIColor.gray500, for: .normal)
            button.layer.borderWidth = 0
        }
        
        // 선택된 버튼 초기화
        selectedButton = nil
        
    }
    
    func handleLastQuestion() {
        print(buttonIndexList)
        print("Push To NextVC")
    }
    
    func setAnimation() {
        let viewsToAnimate = [firstButton.titleLabel, secondButton.titleLabel,
                              thirdButton.titleLabel, fourthButton.titleLabel]

        UIView.animate(withDuration: 0.5, animations: {
            viewsToAnimate.forEach { $0?.alpha = 0.0 }
        }) { [self] _ in
            // fade out 애니메이션 종료 후 실행될 코드
            updateLabel()
            UIView.animate(withDuration: 0.5) {
                viewsToAnimate.forEach { $0?.alpha = 1.0 }
            }
        }
    }
    
    @objc
    func buttonTapped(_ sender: UIButton) {
        
        guard let buttonIndex = questionStackView.arrangedSubviews.firstIndex(of: sender) else {
            return
        }
        print("Button Tapped: \(sender.title(for: .normal) ?? ""), Index: \(buttonIndex)")
        self.buttonIndex = buttonIndex
        
        // 클릭안된 다른 버튼들의 색상 변경
        for case let button as UIButton in questionStackView.arrangedSubviews {
            button.backgroundColor = .gray50
            button.layer.borderWidth = 0
        }
        
        // 클릭된 버튼의 색상 변경
        sender.backgroundColor = .white000
        sender.layer.borderColor = UIColor.red500.cgColor
        sender.layer.borderWidth = 1
        sender.titleLabel?.textColor = .gray700
        
        selectedButton = sender
        
        // nextButton 상태 갱신
        updateNextButtonState()
 
    }
    
    @objc
    func nextButtonTapped() {
        resetButtons()
        if index < userTestDataStruct.count - 1 {
            
            // 질문이 마지막이 아닌 경우
            testProgressView.setProgress(testProgressView.progress + 0.1111111, animated: true)
            index += 1
            setAnimation()
            buttonIndexList.append(self.buttonIndex)
            
            // nextButton 상태 초기화
            nextButton.backgroundColor = .gray50
            nextButton.setTitleColor(.gray200, for: .normal)
            updateNextButtonState()
            
        } else {
            // 질문이 마지막인 경우
            setAnimation()
            buttonIndexList.append(self.buttonIndex)
            handleLastQuestion()
            
        }
        if index == 8 {
            nextButton.setTitle("제출하기", for: .normal)
            updateNextButtonState()
        }
    }
}

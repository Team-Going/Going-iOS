//
//  TravelTestCollectionViewCell.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/6/24.
//

import UIKit

import SnapKit

protocol TravelTestCollectionViewCellDelegate: AnyObject {
    func didSelectAnswer(in cell: TravelTestCollectionViewCell, selectedAnswer: Int)
}

final class TravelTestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    weak var delegate: TravelTestCollectionViewCellDelegate?
        
    var travelTestData: TravelTestQuestionStruct? {
        didSet {
            guard let data = travelTestData else { return }
            self.questionIndexLabel.text = "0\(data.questionIndex)"
            self.questionLabel.text = data.questionContent
            self.leftOptionLabel.text = data.optionContent.leftOption
            self.middleOptionLabel.text = data.optionContent.middleOption
            self.rightOptionLabel.text = data.optionContent.rightOption
        }
    }
        
    var styleResult: Int? {
        didSet {
            guard let value = styleResult else { return }
            setStyleTagResultButton(result: value)
        }
    }

    // MARK: - UI Components
    
    private let indexBackgroundImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(resource: .imgRoundBackground)
        return img
    }()

    private let questionIndexLabel = DOOLabel(font: .pretendard(.detail3_regular), color: UIColor(resource: .white000))
    
    private let questionLabel = DOOLabel(font: .pretendard(.body3_medi), color: UIColor(resource: .gray700))
  
    private let answerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var answerButtons = [UIButton]()

    private let leftOptionLabel = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700))
  
    private let middleOptionLabel = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700))
  
    private let rightOptionLabel = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700))
    
    // MARK: - Life Cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setHierarchy()
        setButton()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 취향 태그 결과값에 따라 버튼 색상 세팅하는 메소드
    func setStyleTagResultButton(result: Int) {
        answerButtons[result-1].backgroundColor = UIColor(resource: .gray400)
    }
    
    // 프로필 조회 시 취향 태그 버튼 비활성화하는 메소드
    func setButtonDisable() {
        for index in 0...4 {
            answerButtons[index].isEnabled = false
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    func answerButtonTapped(_ sender: UIButton) {
        answerButtons.forEach { $0.backgroundColor = UIColor(resource: .gray50) }
        sender.backgroundColor = UIColor(resource: .gray400)
        delegate?.didSelectAnswer(in: self, selectedAnswer: sender.tag)
    }
}

// MARK: - Private Methods

private extension TravelTestCollectionViewCell {
    func setStyle() {
        backgroundColor = UIColor(resource: .white000)
        layer.cornerRadius = 6
        layer.borderColor = UIColor(resource: .gray100).cgColor
        layer.borderWidth = 1
    }
    
    func setHierarchy() {
        addSubviews(indexBackgroundImage,
                    questionLabel,
                    answerStackView,
                    leftOptionLabel,
                    middleOptionLabel,
                    rightOptionLabel)
        indexBackgroundImage.addSubview(questionIndexLabel)
    }
    
    func setLayout() {
        indexBackgroundImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.width.equalTo(ScreenUtils.getWidth(34))
            $0.height.equalTo(ScreenUtils.getHeight(22))
            $0.centerX.equalToSuperview()
        }
        
        questionIndexLabel.snp.makeConstraints {
            $0.center.equalTo(indexBackgroundImage)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(indexBackgroundImage.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        answerStackView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(15)
        }
        
        leftOptionLabel.snp.makeConstraints {
            $0.top.equalTo(answerStackView.snp.bottom).offset(4)
            $0.centerX.equalTo(answerButtons[0])
        }
        
        middleOptionLabel.snp.makeConstraints {
            $0.top.equalTo(answerStackView.snp.bottom).offset(4)
            $0.centerX.equalTo(answerButtons[2])
        }
        
        rightOptionLabel.snp.makeConstraints {
            $0.top.equalTo(answerStackView.snp.bottom).offset(4)
            $0.centerX.equalTo(answerButtons[4])
        }
    }
    
    func createButton(tag: Int) -> UIButton {
        let button = UIButton()
        button.tag = tag
        button.backgroundColor = UIColor(resource: .gray50)
        button.addTarget(self, action: #selector(answerButtonTapped(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 4
        return button
    }
    
    func setButton() {
        for i in 1...5 {
            let button = createButton(tag: i)
            answerButtons.append(button)
            answerStackView.addArrangedSubview(button)
            button.snp.makeConstraints {
                $0.width.equalTo(ScreenUtils.getWidth(56))
                $0.height.equalTo(ScreenUtils.getHeight(16))
            }
        }
    }
}

extension TravelTestCollectionViewCell {
    func configureButtonColors(with selectedAnswerIndex: Int?) {
        for (index, button) in answerButtons.enumerated() {
            button.backgroundColor = (index == selectedAnswerIndex) ? UIColor(resource: .gray400) : UIColor(resource: .gray50)
        }
    }
}

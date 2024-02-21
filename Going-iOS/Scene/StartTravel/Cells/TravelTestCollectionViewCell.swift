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

    // MARK: - UI Components
    
    private let indexBackgroundImage: UIImageView = {
        let img = UIImageView()
        img.image = ImageLiterals.TravelTest.indexImage
        return img
    }()
    
    private let questionIndexLabel = DOOLabel(font: .pretendard(.detail3_regular), color: .white000)
    
    private let questionLabel = DOOLabel(font: .pretendard(.body3_medi), color: .gray700)
    
    private let answerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var answerButtons = [UIButton]()
    
    private let leftOptionLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray700)
    
    private let middleOptionLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray700)
    
    private let rightOptionLabel = DOOLabel(font: .pretendard(.detail2_regular), color: .gray700)
    
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
    
    // MARK: - @objc Methods
    
    @objc
    func answerButtonTapped(_ sender: UIButton) {
        answerButtons.forEach { $0.backgroundColor = .gray50 }
        sender.backgroundColor = .gray400
        delegate?.didSelectAnswer(in: self, selectedAnswer: sender.tag)
    }
}

// MARK: - Private Methods

private extension TravelTestCollectionViewCell {
    func setStyle() {
        backgroundColor = .white000
        layer.cornerRadius = 6
        layer.borderColor = UIColor.gray100.cgColor
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
        button.backgroundColor = .gray50
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

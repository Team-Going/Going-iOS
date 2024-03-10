//
//  MemberMultiProgressView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/8/24.
//

import UIKit

import SnapKit
import MultiProgressView

final class MemberMultiProgressView: UIView {
    
    // MARK: - Network
    
    var testResultData: Style? {
        didSet {
            guard let rates = testResultData?.rates else { return }
            
            self.multiProgressView.setProgress(section: 0, to: Float(rates[0]) * 0.01)
            self.multiProgressView.setProgress(section: 1, to: Float(rates[1]) * 0.01)
            self.multiProgressView.setProgress(section: 2, to: Float(rates[2]) * 0.01)
            
            guard let counts = testResultData?.counts else { return }
            
            self.leftOptionStackView.memberCountLabel.text = "\(counts[0])" + "명"
            self.middleOptionStackView.memberCountLabel.text = "\(counts[1])" + "명"
            self.rightOptionStackView.memberCountLabel.text = "\(counts[2])" + "명"
        }
    }
    
    // MARK: - UI Properties
    
    private let questionLabel = DOOLabel(font: .pretendard(.body3_bold),
                                         color: UIColor(resource: .gray700))
    
    private lazy var multiProgressView: MultiProgressView = {
        let progress = MultiProgressView()
        progress.trackBackgroundColor = UIColor(resource: .gray100)
        progress.lineCap = .round
        progress.cornerRadius = 4
        progress.dataSource = self
        return progress
    }()
    
    private let answerOptionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 18
        return stack
    }()
    
    private let leftOptionStackView = AnswerStackView(answerType: .left)
    
    private let middleOptionStackView = AnswerStackView(answerType: .center)
    
    private let rightOptionStackView = AnswerStackView(answerType: .right)
    
    // MARK: - Life Cycles
    
    init(frame: CGRect, testData: MemberTravelTestStruct) {
        super.init(frame: frame)
        
        self.questionLabel.text = testData.questionContent
        self.leftOptionStackView.answerLabel.text = testData.optionContent.leftOption
        self.middleOptionStackView.answerLabel.text = testData.optionContent.middleOption
        self.rightOptionStackView.answerLabel.text = testData.optionContent.rightOption
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MemberMultiProgressView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        self.addSubviews(questionLabel,
                         multiProgressView,
                         answerOptionsStackView)
        
        answerOptionsStackView.addArrangedSubviews(leftOptionStackView,
                                                   middleOptionStackView,
                                                   rightOptionStackView)
    }
    
    func setLayout() {
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        multiProgressView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(10))
        }
        
        answerOptionsStackView.snp.makeConstraints {
            $0.top.equalTo(multiProgressView.snp.bottom).offset(14)
            $0.width.equalTo(ScreenUtils.getWidth(291))
            $0.height.equalTo(ScreenUtils.getHeight(12))
            $0.centerX.equalToSuperview()
        }
    }
}

extension MemberMultiProgressView: MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return 3
    }
    
    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let bar = AnswerProgressSection()
        bar.configure(withAnswerType: AnswerType(rawValue: section) ?? .center)
        return bar
    }
}

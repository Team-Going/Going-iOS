//
//  MemberProgressView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//


import UIKit

import SnapKit

final class MemberProgressView: UIView {
    
    // MARK: - Network
    
    private var tripId = 1
    
    var testResultData: Style? {
        didSet {
            guard let isLeft = testResultData?.isLeft else { return }
            if isLeft {
                self.progressBarView.trackTintColor = UIColor(resource: .gray50)
                self.progressBarView.progressTintColor = UIColor(resource: .gray400)
                self.progressBarView.progress = Float(testResultData?.rate ?? 0) * 0.01
            } else {
                let percentage = Float(testResultData?.rate ?? 0) * 0.01
                self.progressBarView.trackTintColor = UIColor(resource: .gray400)
                self.progressBarView.progressTintColor = UIColor(resource: .gray50)
                self.progressBarView.setProgress(1 - percentage, animated: false)
            }
        }
    }

    // MARK: - UI Properties
    
    private let questionLabel = DOOLabel(font: .pretendard(.body3_bold),
                                         color: UIColor(resource: .gray700), 
                                         text: "여행 스타일")
  
    private let progressBarView: UIProgressView = {
        let view = UIProgressView()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.progressViewStyle = .bar
        return view
    }()

    private let leftOption = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700))
  
    private let rightOption = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700))
    
    // MARK: - Life Cycle

    init(frame: CGRect, testData: MemberTestStruct) {
        super.init(frame: frame)
        self.questionLabel.text = testData.questionContent
        self.leftOption.text = testData.optionContent.leftOption
        self.rightOption.text = testData.optionContent.rightOption
        
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MemberProgressView {
    func setStyle() {
        self.backgroundColor = UIColor(resource: .white000)
    }
    
    func setHierarchy() {
        self.addSubviews(questionLabel, progressBarView, leftOption, rightOption)
    }
    
    func setLayout() {
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(21))
            $0.centerX.equalToSuperview()
        }
        
        progressBarView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(10))
        }
        
        leftOption.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(6)
            $0.leading.equalToSuperview()
        }
        
        rightOption.snp.makeConstraints {
            $0.top.equalTo(progressBarView.snp.bottom).offset(6)
            $0.trailing.equalToSuperview()
        }
    }
}

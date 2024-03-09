//
//  AnswerStackView.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/7/24.
//

import UIKit

import SnapKit

class AnswerStackView: UIStackView {
    
    // MARK: - UI Properties
    
    let answerLabel = DOOLabel(font: .pretendard(.detail3_semi), color: UIColor(resource: .gray400))
    
    private lazy var colorView = UIView()
    
    let memberCountLabel = DOOLabel(font: .pretendard(.detail3_regular), color: UIColor(resource: .gray400))
    
    init(answerType: AnswerType) {
        super.init(frame: .zero)
        alignment = .fill
        spacing = 4
        
        colorView.backgroundColor = answerType.color
        
        setHierarchy()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AnswerStackView {
    func setHierarchy() {
        addArrangedSubviews(colorView, 
                            answerLabel,
                            memberCountLabel)
    }
    
    func setLayout() {
        colorView.snp.makeConstraints {
            $0.size.equalTo(10)
        }
    }
}

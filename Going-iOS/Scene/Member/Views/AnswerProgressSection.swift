//
//  AnswerProgressSection.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/7/24.
//

import UIKit

import MultiProgressView

class AnswerProgressSection: ProgressViewSection {
    
    private let rightBorder: UIView = {
        let border = UIView()
        border.backgroundColor = .clear
        return border
    }()
    
    func configure(withAnswerType answerType: AnswerType) {
        addSubview(rightBorder)
        rightBorder.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(1))
            $0.leading.equalToSuperview()
            $0.height.equalToSuperview()
        }
        backgroundColor = answerType.color
    }
}

//
//  TestResultView.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class TestResultView: UIView {

    private let nameLabel = DOOLabel(font: .pretendard(.body2_medi), color: .gray600)
    private let userTypeLabel = DOOLabel(font: .pretendard(.head1), color: .red500)
    private let subTitleLabel = DOOLabel(font: .pretendard(.detail1_regular), color: .gray300)
    
    private let tagStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var firstTagLabel: DOOLabel = makeLabel()
    private lazy var secondTagLabel: DOOLabel = makeLabel()
    private lazy var thirdTagLabel: DOOLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.text = "곽성준은"
        userTypeLabel.text = "여행을 좋아해"
        userTypeLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TestResultView {
    func makeLabel() -> DOOLabel {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .red300)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.red300.cgColor
        label.layer.cornerRadius = 10
        return label
    }
    
    func setHierarchy() {
        self.addSubviews(nameLabel, userTypeLabel, subTitleLabel, tagStackView)
        tagStackView.addArrangedSubviews(firstTagLabel, secondTagLabel, thirdTagLabel)
    }
    
    func setLayout() {
        
    }
    
    func setStyle() {
        
    }
}

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
    
    private let ticketStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    private let firstTickeView = TestResultTicketView()
    private let secondTickeView = TestResultTicketView()
    private let thirdTickeView = TestResultTicketView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.text = "곽성준은"
        userTypeLabel.text = "여행을 좋아해"
        subTitleLabel.text = "여행좋아함"
        
        setHierarchy()
        setLayout()
        setStyle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TestResultView {
    func makeLabel() -> DOOLabel {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .red300, alignment: .center)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.red300.cgColor
        label.layer.cornerRadius = 10
        label.text = "test"
        return label
    }
    
    func setHierarchy() {
        self.addSubviews(nameLabel, userTypeLabel, subTitleLabel, tagStackView, firstTickeView, ticketStackView)
        ticketStackView.addArrangedSubviews(firstTickeView, secondTickeView, thirdTickeView)
        tagStackView.addArrangedSubviews(firstTagLabel, secondTagLabel, thirdTagLabel)
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
        
        userTypeLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userTypeLabel.snp.bottom).offset(1)
            $0.centerX.equalToSuperview()
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        ticketStackView.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        
        firstTagLabel.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(55))
            $0.height.equalTo(ScreenUtils.getHeight(20))
        }
        
    }
    
    func setStyle() {
        self.roundCorners(cornerRadius: 8, maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner])
        self.backgroundColor = .white000
    }
}

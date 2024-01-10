//
//  MyResultView.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/11/24.
//

import UIKit

import SnapKit

final class MyResultView: UIView {
    
    private let userTypeLabel = DOOLabel(font: .pretendard(.body1_bold), color: .gray700)
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
    
    private let firstTicketView = TestResultTicketView()
    private let secondTicketView = TestResultTicketView()
    private let thirdTicketView = TestResultTicketView()
    
    private lazy var backToTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 해볼래요", for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(.gray300, for: .normal)
        button.setUnderline()
        return button
    }()
    
    private let whiteView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userTypeLabel.text = "배려심 많은 인간 플래너"
        subTitleLabel.text = "꼼꼼하고 세심하게 여행을 준비하는 친구!"
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MyResultView {
    func makeLabel() -> DOOLabel {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .red300, alignment: .center)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.red300.cgColor
        label.layer.cornerRadius = 10
        label.text = "test"
        return label
    }
    
    func setHierarchy() {
        self.addSubviews(userTypeLabel,
                         subTitleLabel,
                         tagStackView,
                         firstTicketView,
                         ticketStackView,
                         backToTestButton,
                         whiteView)
        ticketStackView.addArrangedSubviews(firstTicketView, secondTicketView, thirdTicketView)
        tagStackView.addArrangedSubviews(firstTagLabel, secondTagLabel, thirdTagLabel)
    }
    
    func setLayout() {
        userTypeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userTypeLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        ticketStackView.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(backToTestButton.snp.top).offset(-12)
        }
        
        backToTestButton.snp.makeConstraints {
            $0.trailing.equalTo(ticketStackView.snp.trailing)
            $0.width.equalTo(ScreenUtils.getWidth(66))
            $0.height.equalTo(ScreenUtils.getHeight(18))
            $0.bottom.equalTo(whiteView.snp.top)
        }
        
        whiteView.snp.makeConstraints {
            $0.top.equalTo(backToTestButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(30))
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
        whiteView.backgroundColor = .white000
    }
}


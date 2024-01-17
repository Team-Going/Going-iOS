//
//  TestResultView.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

protocol TestResultViewDelegate: AnyObject {
    func backToTestButton()
}

final class TestResultView: UIView {
    
    weak var delegate: TestResultViewDelegate?
    
    var resultViewData: UserTypeTestResultAppData? {
        didSet {
            guard let data = resultViewData else { return }
            self.userTypeLabel.text = data.userType
            self.typeDescLabel.text = data.userTypeDesc
            self.firstTagLabel.text = data.userTypeTag.firstTag
            self.secondTagLabel.text = data.userTypeTag.secondTag
            self.thirdTagLabel.text = data.userTypeTag.thirdTag
            
            self.firstTickeView.firstString = data.likePoint.firstPoint
            self.firstTickeView.secondString = data.likePoint.secondPoint
            self.firstTickeView.thirdString = data.likePoint.thirdPoint
            
            self.secondTickeView.firstString = data.warningPoint.firstPoint
            self.secondTickeView.secondString = data.warningPoint.secondPoint
            self.secondTickeView.thirdString = data.warningPoint.thirdPoint
            
            self.thirdTickeView.firstString = data.goodToDoPoint.firstPoint
            self.thirdTickeView.secondString = data.goodToDoPoint.secondPoint
            self.thirdTickeView.thirdString = data.goodToDoPoint.thirdPoint
        }
    }
    
    var nameLabel = DOOLabel(font: .pretendard(.body2_medi), color: .gray600)
    
    let userTypeLabel = DOOLabel(font: .pretendard(.head1), color: .red500)
    let typeDescLabel = DOOLabel(font: .pretendard(.detail1_regular), color: .gray300)
    
    private let tagStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
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
    
    private lazy var backToTestButton: UIButton = {
        let button = UIButton()
        button.setTitle("다시 해볼래요", for: .normal)
        button.titleLabel?.font = .pretendard(.detail2_regular)
        button.setTitleColor(.gray300, for: .normal)
        button.setUnderline()
        button.addTarget(self, action: #selector(backToTestButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let whiteView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
        setTicketViewText()
    }
    
    @objc
    func backToTestButtonTapped() {
        delegate?.backToTestButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TestResultView {
    
    func setTicketViewText() {
        self.firstTickeView.titleLabel.text = "이런 점이 \n좋아요"
        self.secondTickeView.titleLabel.text = "이런 점은 \n주의해줘요"
        self.thirdTickeView.titleLabel.text = "이런 걸 \n잘해요"
    }
    
    func makeLabel() -> DOOLabel {
        let label = DOOLabel(font: .pretendard(.detail2_regular), color: .red300, alignment: .center, padding: UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8))
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.red300.cgColor
        label.layer.cornerRadius = 10
        return label
    }
    
    func setHierarchy() {
        self.addSubviews(nameLabel, 
                         userTypeLabel,
                         typeDescLabel,
                         tagStackView,
                         firstTickeView,
                         ticketStackView,
                         backToTestButton,
                         whiteView)
        ticketStackView.addArrangedSubviews(firstTickeView, 
                                            secondTickeView,
                                            thirdTickeView)
        tagStackView.addArrangedSubviews(firstTagLabel, 
                                         secondTagLabel,
                                         thirdTagLabel)
    }
    
    func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        userTypeLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        typeDescLabel.snp.makeConstraints {
            $0.top.equalTo(userTypeLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(typeDescLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        ticketStackView.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(backToTestButton.snp.top).offset(-12)
        }
        
        backToTestButton.snp.makeConstraints {
            $0.top.equalTo(ticketStackView.snp.bottom).offset(12)
            $0.trailing.equalTo(ticketStackView.snp.trailing)
        }
        
        whiteView.snp.makeConstraints {
            $0.top.equalTo(backToTestButton.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(ScreenUtils.getHeight(30))
            $0.bottom.equalToSuperview()
            
        }
    }
    
    func setStyle() {
        self.backgroundColor = .white000
        whiteView.backgroundColor = .white000
    }
}

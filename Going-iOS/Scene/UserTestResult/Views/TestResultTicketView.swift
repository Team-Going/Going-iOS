//
//  TestResultTicketView.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class TestResultTicketView: UIView {
    
    private let wholeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private let titleLabel = DOOLabel(font: .pretendard(.detail2_bold), color: .gray700, numberOfLine: 2, alignment: .center)
    private let vertiLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = ImageLiterals.TestResult.verticalLine
        return imageView
    }()
    
    private let descStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.backgroundColor = .gray200
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var firstDescLabel = makeLabel()
    private lazy var secondDescLabel = makeLabel()
    private lazy var thirdDescLabel = makeLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "성주누누ㄴㄴㄴs"
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TestResultTicketView {
    
    func makeLabel() -> DOOLabel {
        let label = DOOLabel(font: .pretendard(.detail3_regular), color: .gray700, numberOfLine: 2)
        
        let imageAttachment = NSTextAttachment(image: ImageLiterals.TestResult.dotImage)
        imageAttachment.bounds = .init(x: 0, y: ScreenUtils.getHeight(2), width: ScreenUtils.getWidth(4), height: ScreenUtils.getHeight(4))
        label.labelWithImg(composition: NSAttributedString(attachment: imageAttachment), NSAttributedString(string: "  꼼꼼하고 부지런해 맡은 일에서 실수가 적어요ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ"))
        
        return label
    }
    
    func setHierarchy() {
        self.addSubviews(wholeStackView)
        wholeStackView.addArrangedSubviews(titleLabel, vertiLineImageView, descStackView)
        descStackView.addArrangedSubviews(firstDescLabel, secondDescLabel, thirdDescLabel)
    }
    
    func setLayout() {
        wholeStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(ScreenUtils.getHeight(110))
        }
        
        vertiLineImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(52))
            $0.height.equalTo(ScreenUtils.getHeight(36))
        }
        
        descStackView.snp.makeConstraints {
            $0.centerY.equalTo(vertiLineImageView)
            $0.width.equalTo(ScreenUtils.getWidth(213))
        }
    }
    
    func setStyle() {
        self.backgroundColor = .gray50
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor.gray200.cgColor
    }
    
}

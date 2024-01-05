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
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private let titleLabel = DOOLabel(font: .pretendard(.detail2_bold), color: .gray700)
    private let vertiLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = ImageLiterals.TestResult.verticalLine
        return imageView
    }()
    
    private let descStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    private lazy var firstDescLabel = makeLabel()
    private lazy var secondDescLabel = makeLabel()
    private lazy var thirdDescLabel = makeLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "성주누누누누누누눈"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TestResultTicketView {
    
    func makeLabel() -> DOOLabel {
        let label = DOOLabel(font: .pretendard(.detail3_regular), color: .gray700)
        label.text = "성주누눈"
        let imageAttachment = NSTextAttachment(image: ImageLiterals.TestResult.dotImage)
        label.labelWithImg(composition: NSAttributedString(attachment: imageAttachment))
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
        }
        
        vertiLineImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(1)
        }
    }
    
    func setStyle() {
        self.backgroundColor = .white000
    }
    
}

//
//  TestResultTicketView.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

import SnapKit

final class TestResultTicketView: UIView {
    
    var firstString: String = "" {
        didSet {
            let imageAttachment = NSTextAttachment(image: UIImage(resource: .resultDot))
            imageAttachment.bounds = CGRect(x: 0, y: (UIFont.pretendard(.detail3_regular).capHeight - UIImage(resource: .resultDot).size.height).rounded() / 2, width: UIImage(resource: .resultDot).size.width, height: UIImage(resource: .resultDot).size.height)
            firstDescLabel.labelWithImg(composition: NSAttributedString(attachment: imageAttachment), NSAttributedString(string: " \(firstString)"))
        }
    }
    
    var secondString: String = "" {
        didSet {
            let imageAttachment = NSTextAttachment(image: UIImage(resource: .resultDot))
            imageAttachment.bounds = CGRect(x: 0, y: (UIFont.pretendard(.detail3_regular).capHeight - UIImage(resource: .resultDot).size.height).rounded() / 2, width: UIImage(resource: .resultDot).size.width, height: UIImage(resource: .resultDot).size.height)
            secondDescLabel.labelWithImg(composition: NSAttributedString(attachment: imageAttachment), NSAttributedString(string: " \(secondString)"))
        }
    }
    
    var thirdString: String = "" {
        didSet {
            let imageAttachment = NSTextAttachment(image: UIImage(resource: .resultDot))
            imageAttachment.bounds = CGRect(x: 0, y: (UIFont.pretendard(.detail3_regular).capHeight - UIImage(resource: .resultDot).size.height).rounded() / 2, width: UIImage(resource: .resultDot).size.width, height: UIImage(resource: .resultDot).size.height)
            thirdDescLabel.labelWithImg(composition: NSAttributedString(attachment: imageAttachment), NSAttributedString(string: " \(thirdString)"))
        }
    }
    
    private let ticketBackgroundImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(resource: .boxDescriptionIos)
        return img
    }()
    
    private let wholeStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 32
        stack.alignment = .center
        return stack
    }()
    
    let titleLabel = DOOLabel(font: .pretendard(.detail1_bold), color: UIColor(resource: .gray700), numberOfLine: 2, alignment: .center)
    
    private let descStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.backgroundColor = .clear
        return stack
    }()
    
    lazy var firstDescLabel = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700), numberOfLine: 2)
    lazy var secondDescLabel = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700), numberOfLine: 2)
    lazy var thirdDescLabel = DOOLabel(font: .pretendard(.detail2_regular), color: UIColor(resource: .gray700), numberOfLine: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TestResultTicketView {
    
    func setHierarchy() {
        self.addSubviews(ticketBackgroundImage)
        ticketBackgroundImage.addSubview(wholeStackView)
        wholeStackView.addArrangedSubviews(titleLabel, descStackView)
        descStackView.addArrangedSubviews(firstDescLabel, secondDescLabel, thirdDescLabel)
    }
    
    func setLayout() {
        ticketBackgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        wholeStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.top.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(ScreenUtils.getHeight(110))
        }

        titleLabel.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(52))
            $0.height.equalTo(ScreenUtils.getHeight(36))
        }
        
        descStackView.snp.makeConstraints {
            $0.centerY.equalTo(ticketBackgroundImage)
            $0.width.equalTo(ScreenUtils.getWidth(213))
        }
    }
    
    func setStyle() {
        self.backgroundColor = UIColor(resource: .red100)
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 6
        self.layer.borderColor = UIColor(resource: .gray100).cgColor
    }
}

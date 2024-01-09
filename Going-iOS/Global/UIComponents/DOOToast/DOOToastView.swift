//
//  DOOToastView.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

final class DOOToastView: UIView {
    
    private let messageLabel = UILabel()
    
    init(message: String) {
        super.init(frame: .zero)
        self.messageLabel.text = message
        self.setHierarchy()
        self.setLayout()
        self.setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DOOToastView {
    
    func setHierarchy() {
        self.addSubview(messageLabel)
        
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(ScreenUtils.getWidth(230))
            $0.height.equalTo(ScreenUtils.getHeight(40))
            
        }
        self.messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    func setStyle() {
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
        self.backgroundColor = .gray700
        self.messageLabel.font = .pretendard(.detail2_regular)
        self.messageLabel.textAlignment = .center
        self.messageLabel.textColor = .white000
    }
}


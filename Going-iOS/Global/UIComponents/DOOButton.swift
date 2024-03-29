//
//  DOOButton.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/4/24.
//

import UIKit

import UIKit
import SnapKit


/// 사용 예시
/// 선언) let myButton = DOOButton(type: .unabled, title: "시작하기")
/// 활성화 버튼으로 변경) myButton.currentType = .enabled

class DOOButton: UIButton {
    
    enum ButtonType {
        case enabled
        case unabled
        case white
    }
    
    // 현재 버튼 타입
    var currentType: ButtonType = .unabled {
        didSet {
            updateButtonStyle()
        }
    }
    
    init(type: ButtonType, title: String) {
        super.init(frame: .zero)
        
        self.currentType = type
        commonInit()
        self.setTitle(title, for: .normal)
        updateButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DOOButton {
    
    private func commonInit() {
        self.layer.cornerRadius = 6
        self.isUserInteractionEnabled = true
        self.titleLabel?.font = .pretendard(.body1_bold)
    }
    
    private func updateButtonStyle() {
        switch currentType {
        case .enabled:
            self.backgroundColor = UIColor(resource: .gray500)
            self.layer.borderColor = UIColor.clear.cgColor
            self.setTitleColor(UIColor(resource: .white000), for: .normal)
            self.isEnabled = true
            
        case .unabled:
            self.backgroundColor = UIColor(resource: .gray50)
            self.layer.borderColor = UIColor.clear.cgColor
            self.setTitleColor(UIColor(resource: .gray200), for: .normal)
            self.isEnabled = false
            
        case .white:
            self.backgroundColor = UIColor(resource: .white000)
            self.layer.borderColor = UIColor(resource: .gray200).cgColor
            self.setTitleColor(UIColor(resource: .gray600), for: .normal)
            self.isEnabled = true
            self.layer.borderWidth = 1
        }
    }
}

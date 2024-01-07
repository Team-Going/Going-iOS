//
//  UILabel+.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//
import UIKit

extension UILabel {
        func labelWithImg(composition: NSAttributedString...) {
            let attributedString = NSMutableAttributedString()
            for i in composition {
            attributedString.append(i)
            }
        self.attributedText = attributedString
    }
    
    /// 텍스트필드 위 라벨 세팅 메서드
    func setTitleLabel(title: String) {
        self.text = title
        self.font = .pretendard(.body2_bold)
        self.textColor = .gray700
        self.backgroundColor = .white000
        self.textAlignment = .left
    }
}

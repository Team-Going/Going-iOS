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
    
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }
        
        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                     value: style,
                                     range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}

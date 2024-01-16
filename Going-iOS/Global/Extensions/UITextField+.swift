//
//  UITextField+.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/23/23.
//

import UIKit

extension UITextField {
     func setLeftPadding(amount: CGFloat) {
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
         self.leftView = paddingView
         self.leftViewMode = .always
     }
     func setRightPadding(amount: CGFloat) {
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
         self.rightView = paddingView
         self.rightViewMode = .always
     }

    /// UITextField의 상태를 리턴함
    var isEmpty: Bool {
        if text?.isEmpty ?? true {
            return true
        }
        return false
    }

    /// 자간 설정 메서드
    func setCharacterSpacing(_ spacing: CGFloat) {
        let attributedStr = NSMutableAttributedString(string: self.text ?? "")
        attributedStr.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, attributedStr.length))
        self.attributedText = attributedStr
     }
    
    //placeholder 커스텀
    func setPlaceholder(placeholder: String, fontColor: UIColor?, font: UIFont) {
        self.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                        attributes: [.foregroundColor: fontColor!,
                                                                     .font: font])
    }
    
    func setTextField(forPlaceholder: String, forBorderColor: UIColor, forCornerRadius: CGFloat? = nil) {
        self.placeholder = forPlaceholder
        self.clipsToBounds = true
        self.layer.borderColor = forBorderColor.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .white
        
        if let cornerRadius = forCornerRadius {
            self.layer.cornerRadius = cornerRadius
        }  else {
            self.layer.cornerRadius = 0
        }
    }
    
    func setPlaceholderColor(_ placeholderColor: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [
                .foregroundColor: placeholderColor,
                .font: font
            ].compactMapValues { $0 }
        )
    }
 }

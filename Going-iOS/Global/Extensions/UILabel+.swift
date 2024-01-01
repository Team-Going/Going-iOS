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
}

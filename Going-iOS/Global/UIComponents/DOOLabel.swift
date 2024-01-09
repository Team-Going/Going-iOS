//
//  DOOLabel.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit


final class DOOLabel: UILabel {
    
    private var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    init(font: UIFont,
         color: UIColor,
         text: String? = nil,
         numberOfLine: Int = 1,
         alignment: NSTextAlignment = .left,
         padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.text = text
        self.numberOfLines = numberOfLine
        self.textAlignment = alignment
        self.padding = padding
        
        //글자단위로 줄바꿈
        self.lineBreakMode = .byCharWrapping
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right

        return contentSize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

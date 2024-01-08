//
//  DOOLabel.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit


final class DOOLabel: UILabel {
    
    init(font: UIFont,
         color: UIColor,
         text: String? = nil,
         numberOfLine: Int = 1,
         alignment: NSTextAlignment = .left) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.text = text
        self.numberOfLines = numberOfLine
        self.textAlignment = alignment
        
        //글자단위로 줄바꿈
        self.lineBreakMode = .byCharWrapping
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
         text: String? = nil) {
        super.init(frame: .zero)
        self.font = font
        self.textColor = color
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

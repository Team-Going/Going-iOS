//
//  DOOPopUpContainerView.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

final class DOOPopUpContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white000
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

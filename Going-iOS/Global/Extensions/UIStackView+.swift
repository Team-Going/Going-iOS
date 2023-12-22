//
//  UIStackView+.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/23/23.
//

import UIKit

extension UIStackView {
     func addArrangedSubviews(_ views: UIView...) {
         for view in views {
             self.addArrangedSubview(view)
         }
     }
}

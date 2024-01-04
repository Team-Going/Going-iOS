//
//  UIView+.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/23/23.
//

import UIKit

extension UIView {
    
    // UIView 여러 개 인자로 받아서 한 번에 addSubview
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    //모서리둥글게
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
    
    //그라데이션
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -0.29, b: 0, c: 0, d: -0.25, tx: 0.18, ty: 0.62))
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.05, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}

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
    
    // TODO: - constant 활용하여 변경하기
    
//    // MARK: - 기기 대응
//
//    func getDeviceWidth() -> CGFloat {
//        return UIScreen.main.bounds.width
//    }
//    
//    func getDeviceHeight() -> CGFloat {
//        return UIScreen.main.bounds.height
//    }
//    
//    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
//    func convertByWidthRatio(_ convert: CGFloat) -> CGFloat {
//        return convert * (getDeviceWidth() / 375)
//    }
//    
//    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
//    func convertByHeightRatio(_ convert: CGFloat) -> CGFloat {
//        return convert * (getDeviceHeight() / 812)
//    }
//    
//    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
//    func convertByReverseWidthRatio(_ convert: CGFloat) -> CGFloat {
//        return convert * (375 / getDeviceWidth())
//    }
//    
//    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
//    func convertByReverseHeightRatio(_ convert: CGFloat) -> CGFloat {
//        return convert * (812 / getDeviceHeight())
//    }
//    
//    /// 노치가 있는지 없는지 Bool 값 반환
//    var hasNotch: Bool {
//        return !( (UIScreen.main.bounds.width / UIScreen.main.bounds.height) > 0.5 )
//    }
}

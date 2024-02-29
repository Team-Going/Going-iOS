//
//  UIFont+.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

enum FontName {
    case head1, head2, head3, head4
    case body1_bold, body1_medi, body2_bold, body2_medi, body3_bold, body3_medi
    case detail1_bold, detail1_regular, detail2_bold, detail2_regular, detail3_regular, detail3_semi
    
    var rawValue: String {
        switch self {
        case .head1:
            return "Pretendard-ExtraBold"
        case .head2, .body1_bold, .body2_bold, .body3_bold, .detail1_bold, .detail2_bold:
            return "Pretendard-Bold"
        case .head3:
            return "Pretendard-SemiBold"
        case .head4, .body1_medi, .body2_medi, .body3_medi, .detail3_semi:
            return "Pretendard-Medium"
        case .detail1_regular, .detail2_regular, .detail3_regular:
            return "Pretendard-Regular"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .head1:
            return 24
        case .head2:
            return 22
        case .head3:
            return 20
        case .head4:
            return 18
        case .body1_bold, .body1_medi:
            return 16
        case .body2_bold, .body2_medi:
            return 15
        case .body3_bold, .body3_medi:
            return 14
        case .detail1_bold, .detail1_regular:
            return 13
        case .detail2_bold, .detail2_regular:
            return 12
        case .detail3_regular:
            return 11
        case .detail3_semi:
            return 11
        }
    }
}

extension UIFont {
    static func pretendard(_ style: FontName) -> UIFont {
        return UIFont(name: style.rawValue, size: style.size)!
    }
}

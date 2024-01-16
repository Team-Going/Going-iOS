//
//  ScreenUtils.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

final class ScreenUtils {

    /// Width 375 기준으로 너비 비율에 맞는 width값을 가져오는 메서드
    /// - Parameter value: 설정하고자 하는 너비값
    /// - Returns: 위 비율로 재계산된 너비값
    static func getWidth(_ value: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let standardWidth: CGFloat = 375.0
        return width / standardWidth * value
    }

    /// Height 812 기준으로 높이 비율에 맞는 height값을 가져오는 메서드
    /// - Parameter value: 설정하고자 하는 높이값
    /// - Returns: 위 비율로 재계산된 높이값
    static func getHeight(_ value: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let standardheight: CGFloat = 812.0
        return height / standardheight * value
    }
}

//
//  UIWindow+.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

extension UIWindow {
    public static var current: UIWindow? {
        UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
}

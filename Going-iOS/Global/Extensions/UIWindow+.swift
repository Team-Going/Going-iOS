//
//  UIWindow+.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

extension UIWindow {
    public static var current: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })
    }
}

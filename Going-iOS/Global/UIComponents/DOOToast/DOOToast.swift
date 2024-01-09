//
//  DOOToast.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/9/24.
//

import UIKit

import SnapKit

final class DOOToast {
    static func show (message: String, duration: TimeInterval = 1, insetFromBottom: ConstraintInsetTarget, completion: (() -> Void)? = nil) {
        let toastView = DOOToastView(message: message)
        guard let window = UIWindow.current else { return }
        window.subviews
            .filter { $0 is DOOToastView }
            .forEach { $0.removeFromSuperview() }
        window.addSubview(toastView)
        
        toastView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(insetFromBottom)
            $0.centerX.equalToSuperview()
        }
        
        window.layoutSubviews()
        
        fadeIn(completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                fadeOut(completion: {
                    completion?()
                })
            }
        })
        
        func fadeIn(completion: (() -> Void)? = nil) {
            toastView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                toastView.alpha = 1
            } completion: { _ in
                completion?()
            }

        }
        
        func fadeOut(completion: (() -> Void)? = nil) {
            toastView.alpha = 1
            UIView.animate(withDuration: 0.5) {
                toastView.alpha = 0
            } completion: { _ in
                toastView.removeFromSuperview()
                completion?()
            }
        }
    }
}

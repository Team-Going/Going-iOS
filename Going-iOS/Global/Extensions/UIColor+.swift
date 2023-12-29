//
//  UIColor+.swift
//  Going-iOS
//
//  Created by 곽성준 on 12/29/23.
//

import UIKit

extension UIColor {
    static var red600: UIColor {
        return UIColor(hex: "#E03600")
    }
    static var red500: UIColor {
        return UIColor(hex: "#FF4F17")
    }
    static var red400: UIColor {
        return UIColor(hex: "#FE6032")
    }
    static var red300: UIColor {
        return UIColor(hex: "#FE8763")
    }
    static var red200: UIColor {
        return UIColor(hex: "#FCAD95")
    }
    static var red100: UIColor {
        return UIColor(hex: "#FAD3C6")
    }
    static var gray900: UIColor {
        return UIColor(hex: "#15171E")
    }
    static var gray700: UIColor {
        return UIColor(hex: "#1D1F29")
    }
    static var gray600: UIColor {
        return UIColor(hex: "#292C3C")
    }
    static var gray500: UIColor {
        return UIColor(hex: "#36394F")
    }
    static var gray400: UIColor {
        return UIColor(hex: "#4A4D63")
    }
    static var gray300: UIColor {
        return UIColor(hex: "#9093A8")
    }
    static var gray200: UIColor {
        return UIColor(hex: "#C3C4CE")
    }
    static var gray50: UIColor {
        return UIColor(hex: "#F3F3F6")
    }
    static var black000: UIColor {
        return UIColor(hex: "151515")
    }
    static var white000: UIColor {
        return UIColor(hex: "FFFFFF")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}

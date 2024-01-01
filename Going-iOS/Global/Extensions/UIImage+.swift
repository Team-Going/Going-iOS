//
//  UIImage+.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import UIKit

extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}

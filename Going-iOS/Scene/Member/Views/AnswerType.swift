//
//  AnswerType.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/6/24.
//

import UIKit

enum AnswerType: Int {
    case left, center, right
    
    static var allTypes: [AnswerType] = [.left, .center, .right]

    var color: UIColor {
        switch self {
        case .left:
            return UIColor(resource: .gray400)
        case .center:
            return UIColor(resource: .gray300)
        case .right:
            return UIColor(resource: .gray100)
        }
    }
}

//
//  HapticService.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/2/24.
//

import UIKit

enum HapticService {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection
    
    func run() {
        switch self {
        case let .impact(style):
            /*
             - light : 작거나 가벼운 UI objects 간의 충돌 표현 시
             - medium : 중간 사이즈 UI objects 간의 충돌 표현 시
             - heavy : 크거나 무거운 UI objects 간의 충돌 표현 시
             - rigid : 딱딱하거나 유연하지 않은 UI objects 간의 충돌 표현 시
             - soft : 부드럽거나 유연한 UI objects 간의 충돌 표현 시 
             */
            
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
            
        case let .notification(type):
            /*
             - success : 작업이나 액션이 성공했다는 걸 표현 시
             - warning : 작업이나 액션에서 문제가 생겼다거나 주의를 표현 시
             - error : 작업이나 액션이 실패했다는 걸 표현 시
             */
            
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
            
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}

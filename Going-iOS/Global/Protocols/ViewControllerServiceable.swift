//
//  ViewControllerServiceable.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import UIKit

/// 네트워크 요청을 하는 ViewController가 채택하는 프로토콜
protocol ViewControllerServiceable where Self: UIViewController {

    /// 네트워크 통신을 do-catch문으로 감싸고 catch문에서 호출하는 메서드
    /// - Parameter error: 네트워크 통신 중 throw된 에러
    func handleError(_ error: NetworkError)
}


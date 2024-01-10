//
//  NameSpace.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

typealias Request = Encodable
typealias Response = Decodable

enum UserDefaultKey {
    static let token = "TOKEN"
}

enum SocialLoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
}

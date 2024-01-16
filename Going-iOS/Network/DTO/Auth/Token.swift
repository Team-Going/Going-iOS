//
//  Token.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

/// Request와 Response의 data구조 모두 동일하기 때문에 Codable 채택
struct Token: Codable, DTO {
    let accessToken: String
    let refreshToken: String
}

//
//  LoginDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

//isResult가 true -> 대쉬보드
//isResult가 false -> 성향테스트스플래시
struct LoginResponseDTO: Codable, DTO {
    let accessToken, refreshToken: String
    let isResult: Bool
}

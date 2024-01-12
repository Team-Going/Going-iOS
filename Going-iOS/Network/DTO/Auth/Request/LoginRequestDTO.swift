//
//  LoginRequestDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

//로그인 통신할 때, 애플인지 카카오 인지
//String(apple, kakao)
struct LoginRequestDTO: DTO, Request {
    let platform: String
}

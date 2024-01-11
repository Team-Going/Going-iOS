//
//  SignUpRequestDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

struct SignUpRequestDTO: DTO, Request {
    let name: String
    let intro: String
    let platform: String
}

//
//  SignUpResponseDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

struct SignUpResponseDTO: DTO, Response {
    let accessToken: String
    let refreshToken: String
    let userId: Int
}

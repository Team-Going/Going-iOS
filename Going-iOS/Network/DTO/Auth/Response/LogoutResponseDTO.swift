//
//  LogoutResponseDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/14/24.
//

import Foundation

struct LogoutResponseDTO: Response, DTO {
    let status: Int
    let code: String
    let message: String
}


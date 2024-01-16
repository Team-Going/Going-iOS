//
//  SplashResponseDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

struct SplashResponseDTO: Response, DTO {
    let status: Int
    let code: String
    let message: String
}

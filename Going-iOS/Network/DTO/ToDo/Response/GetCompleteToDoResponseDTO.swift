//
//  GetCompleteToDoResponseDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/14/24.
//

import Foundation

struct GetCompleteToDoResponseDTO: Response, DTO {
    let status: Int
    let code: String
    let message: String
}

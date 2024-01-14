//
//  GetDetailToDoResponseDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct GetDetailToDoResponseDTO: DTO, Response {
    let title, endDate: String
    let allocators: [Allocators]
    let memo: String
    let secret: Bool
}

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

extension GetDetailToDoResponseDTO {
    func toAppData() -> DetailToDoAppData {
        return DetailToDoAppData(title: self.title, endDate: self.endDate, allocators: self.allocators, memo: self.memo, secret: self.secret)
    }
}

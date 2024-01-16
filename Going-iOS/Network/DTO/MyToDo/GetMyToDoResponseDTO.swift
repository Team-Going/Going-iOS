//
//  GetDetailMyToDoDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/11/24.
//

import Foundation

struct GetMyToDoResponseDTO: DTO, Response {
    let participantId: Int
    let title: String
    let count: Int
}

extension GetMyToDoResponseDTO {
    func toAppData() -> MyToDoHeaderAppData {
        return MyToDoHeaderAppData(participantId: self.participantId, title: self.title, count: self.count)
    }
}

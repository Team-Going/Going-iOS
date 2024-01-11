//
//  GetDetailMyToDoDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/11/24.
//

import Foundation

struct GetMyToDoResponseDTO: DTO, Response {
    let name: String
    let count: Int
}

extension GetMyToDoResponseDTO {
    func toAppData() -> MyToDoHeaderAppData {
        return MyToDoHeaderAppData(name: self.name, count: self.count)
    }
}

//
//  CodeResponseDTO.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CodeResponseDTO : Response, DTO {
    let tripId: Int
    let title, startDate, endDate: String
    let day: Int
}

extension CodeResponseDTO {
    func toAppData() -> JoiningSuccessAppData {
        return JoiningSuccessAppData(travelId: self.tripId,
                                     travelName: self.title,
                                     startDate: self.startDate,
                                     endDate: self.endDate,
                                     dueDate: self.day)
    }
}

//
//  CreateTravelResponseDTO.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreateTravelResponseDTO : Response, DTO {
    let tripId: Int64
    let title, startDate, endDate, code: String
    let day: Int
}

extension CreateTravelResponseDTO {
    func toCreatingSuccessAppData() -> CreatingSuccessAppData {
        return CreatingSuccessAppData(travelId: self.tripId,
                                      travelTitle: self.title,
                                      startDate: self.startDate,
                                      endDate: self.endDate,
                                      inviteCode: self.code,
                                      dueDate: self.day)
    }
}

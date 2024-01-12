//
//  CreateTravelResponseDTO.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreateTravelResponseDTO : Response, DTO {
    let tripId: Int
    let title, startDate, endDate, code: String
    let day: Int
}

extension CreateTravelResponseDTO {
    func toAppData() -> CreateTravelResponseAppData {
        return CreateTravelResponseAppData(tripId: self.tripId, title: self.title, startDate: self.startDate, endDate: self.endDate, code: self.code, day: self.day)
    }
}

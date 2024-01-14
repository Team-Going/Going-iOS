//
//  CreatingSuccessAppData.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreateTravelRequestAppData: AppData {
    var travelTitle, startDate, endDate: String
    var a, b, c, d, e: Int
}

extension CreateTravelRequestAppData {
    func toDTOData() -> CreateTravelRequestDTO {
        return CreateTravelRequestDTO(title: self.travelTitle, startDate: self.startDate, endDate: self.endDate, styleA: self.a, styleB: self.b, styleC: self.c, styleD: self.d, styleE: self.e)
    }
}

//
//  CreateTravelRequestDTO.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreateTravelRequestDTO: Request, DTO {
    var title, startDate, endDate: String
    var styleA, styleB, styleC, styleD, styleE: Int
}

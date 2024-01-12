//
//  CreateTravelRequestDTO.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreateTravelRequestDTO: Request, DTO {
    let title, startDate, endDate: String
    let styleA, styleB, styleC, styleD, styleE: Int
}

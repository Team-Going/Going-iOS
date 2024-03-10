//
//  TravelDetailResponseStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/9/24.
//

import Foundation

// MARK: - TravelDetailResponseStruct

struct TravelDetailResponseStruct: Response {
    let tripID: Int
    var title, startDate, endDate: String

    enum CodingKeys: String, CodingKey {
        case tripID = "tripId"
        case title, startDate, endDate
    }
}

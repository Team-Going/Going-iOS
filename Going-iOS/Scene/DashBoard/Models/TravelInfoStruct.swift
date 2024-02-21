//
//  TravelInfoStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/7/24.
//

import UIKit

struct TravelInfoStruct {
    let userName: String
    let detailInfos: [TravelDetailStruct]
}

struct TravelDetailStruct {
    let travelId: Int
    let travelTitle: String
    let startDate: String
    let endDate: String
    let dueDate: Int
}

extension Trip {
    var travelStatus: String {
        if day == 0 {
            return "여행 중"
        } else if day > 0 {
            return "D-\(day)"
        } else {
            return "여행종료"
        }
    }
}

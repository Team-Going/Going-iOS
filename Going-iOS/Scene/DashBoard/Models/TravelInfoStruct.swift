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

extension TravelInfoStruct {
    static let travelInfoDummy: TravelInfoStruct =
        TravelInfoStruct(userName: "일지민", detailInfos: [
            TravelDetailStruct(travelId: 1, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: 8),
            TravelDetailStruct(travelId: 2, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -1),
            TravelDetailStruct(travelId: 3, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -3),
            TravelDetailStruct(travelId: 4, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -22),
            TravelDetailStruct(travelId: 5, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: 9),
            TravelDetailStruct(travelId: 6, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: 0),
            TravelDetailStruct(travelId: 7, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -126),
            TravelDetailStruct(travelId: 8, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -3),
            TravelDetailStruct(travelId: 8, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: 24),
            TravelDetailStruct(travelId: 9, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: 43),
            TravelDetailStruct(travelId: 10, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -12),
            TravelDetailStruct(travelId: 11, travelTitle: "굉굉이랑 합숙", startDate: "2024.01.02", endDate: "2024.01.11", dueDate: -17)
        ])
}

extension TravelDetailStruct {
    var travelStatus: String {
        if dueDate == 0 {
            return "여행중"
        } else if dueDate > 0 {
            return "D-\(dueDate)"
        } else {
            return "여행종료"
        }
    }
}

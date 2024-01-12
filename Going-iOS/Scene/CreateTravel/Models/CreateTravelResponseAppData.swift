//
//  CreateTravelResponseAppData.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreateTravelResponseAppData {
    let tripId: Int
    let title, startDate, endDate, code: String
    let day: Int
}

extension CreateTravelResponseAppData {
    static var emptyData = CreateTravelResponseAppData(tripId: 0, title: "", startDate: "", endDate: "", code: "", day: 0)
}

//
//  DashBoardResponseSturct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/13/24.
//


// MARK: - DashBoard

struct DashBoardResponseSturct: Response {
    let name: String
    let trips: [Trip]
}

// MARK: - Trip

struct Trip: Response {
    let tripID: Int
    let title, startDate, endDate: String
    let day: Int

    enum CodingKeys: String, CodingKey {
        case tripID = "tripId"
        case title, startDate, endDate, day
    }
}

extension DashBoardResponseSturct {
    static var emptyData = DashBoardResponseSturct(name: "", trips: [])
}

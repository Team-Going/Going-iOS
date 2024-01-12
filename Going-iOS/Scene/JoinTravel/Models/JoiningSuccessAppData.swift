//
//  JoiningSuccessAppData.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct JoiningSuccessAppData: AppData {
    let travelId: Int64
    let travelName: String
    let startDate: String
    let endDate: String
    let dueDate: Int
}

extension JoiningSuccessAppData {
    static var EmptyData = JoiningSuccessAppData(travelId: 0, travelName: "", startDate: "", endDate: "", dueDate: 0)
}

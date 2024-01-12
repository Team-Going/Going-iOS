//
//  CreatingSuccessAppData.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import Foundation

struct CreatingSuccessAppData: AppData {
    let travelId: Int64
    let travelTitle, startDate, endDate, inviteCode: String
    let dueDate: Int
}

extension CreatingSuccessAppData {
    static var EmptyData = CreatingSuccessAppData(travelId: 0, 
                                                  travelTitle: "",
                                                  startDate: "",
                                                  endDate: "",
                                                  inviteCode: "",
                                                  dueDate: 0)
}

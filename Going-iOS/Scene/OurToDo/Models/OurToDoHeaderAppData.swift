//
//  OurToDoHeaderAppData.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/11/24.
//

import Foundation

struct OurToDoHeaderAppData: AppData {
    let title: String
    let day: Int
    let startDate, endDate: String
    let progress: Int
    let code: String
    let isComplete: Bool
    let participants: [Participant]
}

extension OurToDoHeaderAppData {
    static var EmptyData = OurToDoHeaderAppData(title: "", day: 0, startDate: "", endDate: "", progress: 0, code: "", isComplete: false, participants: [])
}

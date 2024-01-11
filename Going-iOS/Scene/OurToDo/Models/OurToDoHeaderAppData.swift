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
    let participants: [Participants]
}

struct Participants: AppData {
    let participantID: Int
    let name, result: String
}

extension OurToDoHeaderAppData {
    static var EmptyData = OurToDoHeaderAppData(title: "", day: 0, startDate: "", endDate: "", progress: 0, participants: [])
    
    static func dummy() -> OurToDoHeaderAppData {
        return .init(
            title: "희슬이랑 파리",
            day: 15,
            startDate: "2024.02.15",
            endDate: "2024.02.29",
            progress: 35,
            participants: [
                .init(participantID: 1, name: "희슬1", result: ""),
                .init(participantID: 2, name: "희슬2", result: ""),
                .init(participantID: 3, name: "희슬3", result: ""),
                .init(participantID: 4, name: "희슬4", result: ""),
                .init(participantID: 5, name: "희슬5", result: ""),
            ])
    }
}

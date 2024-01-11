//
//  GetOurToDoHeaderDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/11/24.
//

import Foundation

struct GetOurToDoResponseDTO: DTO, Response {
    let title: String
    let day: Int
    let startDate, endDate: String
    let progress: Int
    let participants: [Participant]
}

struct Participant: DTO, Response {
    let participantID: Int
    let name, result: String
}

extension GetOurToDoResponseDTO {
    func toAppData() -> OurToDoHeaderAppData {
        return OurToDoHeaderAppData(title: self.title, day: self.day, startDate: self.startDate, endDate: self.endDate, progress: self.progress, participants: self.participants)
    }
}

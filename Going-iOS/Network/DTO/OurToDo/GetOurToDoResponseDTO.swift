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
    let code: String
    let isComplete: Bool
    let participants: [Participant]
}

struct Participant: DTO, Response {
    let participantId: Int
    let name: String
    let result: Int
}

extension GetOurToDoResponseDTO {
    func toAppData() -> OurToDoHeaderAppData {
        return OurToDoHeaderAppData(title: self.title, day: self.day, startDate: self.startDate, endDate: self.endDate, progress: self.progress, code: self.code, isComplete: self.isComplete, participants: self.participants)
    }
}

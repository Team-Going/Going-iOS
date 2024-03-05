//
//  GetDetailToDoStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/15/24.
//

import Foundation

struct GetDetailToDoResponseStuct: DTO,  Response {
    let title, endDate: String
    let allocators: [DetailAllocators]
    let memo: String
    let secret: Bool
}

struct DetailAllocators: DTO, Response {
    let participantID: Int
    var name: String
    let isOwner, isAllocated: Bool

    enum CodingKeys: String, CodingKey {
        case participantID = "participantId"
        case name, isOwner, isAllocated
    }
    
    static let SecretData = DetailAllocators(participantID: 0, name: "혼자할일", isOwner: true, isAllocated: true)
    static let SecretInfoData = DetailAllocators(participantID: 0, name: "나만 볼 수 있는 할일이에요", isOwner: false, isAllocated: false)
    
}


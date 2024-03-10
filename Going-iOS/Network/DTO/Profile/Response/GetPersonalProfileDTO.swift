//
//  GetPersonalProfileDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 3/10/24.
//

import Foundation

struct GetPersonalProfileDTO: DTO, Response {
    let name, intro: String
    let result, styleA, styleB, styleC, styleD, styleE: Int
    let isOwner: Bool
}

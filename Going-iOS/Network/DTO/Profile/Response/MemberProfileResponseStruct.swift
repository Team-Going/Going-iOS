//
//  MemberProfileResponseStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/10/24.
//

import Foundation

// MARK: - MemberProfileResponseStruct

struct MemberProfileResponseStruct: Response {
    let name, intro: String
    let result, styleA, styleB, styleC, styleD, styleE: Int
    let isOwner: Bool
}

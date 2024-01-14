//
//  MemberResponseStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//

import Foundation

// MARK: - MemberResponseStruct
struct MemberResponseStruct: Response {
    let participants: [Participant]
    let styles: [Style]
}

// MARK: - Style
struct Style: Response {
    let rate: Int
    let isLeft: Bool
}

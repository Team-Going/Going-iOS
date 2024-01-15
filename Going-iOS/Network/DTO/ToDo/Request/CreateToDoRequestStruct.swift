//
//  CreateToDoRequestStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/15/24.
//

import Foundation

// MARK: - CreateToDoRequest

struct CreateToDoRequestStruct: Request {
    let title: String
    let endDate: String
    let allocators: [Int]
    let memo: String?
    let secret: Bool
}

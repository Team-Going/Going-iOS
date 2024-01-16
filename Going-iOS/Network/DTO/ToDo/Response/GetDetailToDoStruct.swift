//
//  GetDetailToDoStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/15/24.
//

import Foundation

struct GetDetailToDoResponseStuct: Response {
    let title, endDate: String
    let allocators: [Allocators]
    let memo: String
    let secret: Bool
}

//
//  GetDetailToDoStruct.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/14/24.
//

import Foundation

struct GetDetailToDoStuct: Response {
    let title, endDate: String
    let allocators: [Allocators]
    let memo: String
    let secret: Bool
}


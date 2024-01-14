//
//  GetRequestDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct GetToDoRequestDTO: DTO, Request {
    let category: String
    let progress: String
}

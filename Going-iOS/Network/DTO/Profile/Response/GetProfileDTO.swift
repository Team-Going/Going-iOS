//
//  GetProfileDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/11/24.
//

import Foundation

// MARK: - DataClass
struct GetProfileResponseDTO: DTO, Response {
    let name: String
    let intro: String
    let result: Int
}

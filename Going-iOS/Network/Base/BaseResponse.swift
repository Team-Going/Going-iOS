//
//  BaseResponse.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable, DTO {
    let status: Int
    let code: String
    let message: String
    let data: T?
}

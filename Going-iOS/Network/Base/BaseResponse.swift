//
//  BaseResponse.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

struct BaseResponse<T: Response>: Response {
    let status: String
    let message: String
    let code: String
    let data: T?
}

//
//  NetworkErrorCode.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

enum NetworkErrorCode {
    static let clientErrorCode = [
        "e4000", "e4001", "e4010",
        "e4018", "e4019", "e40110", "e40111", "e40112",
        "e40113",
        "e4030",
        "e4050",
        "e4090", "e4091", "e4040",
        "C003"
    ]
    
    static let userState = ["e4041", "e4045"]
    
    //토큰재발급해야됨
    static let unAuthorized = "e4013"

    static let serverErrorCode = "e5000"
}

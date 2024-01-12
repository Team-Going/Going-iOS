//
//  NetworkErrorCode.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

enum NetworkErrorCode {
    static let clientErrorCode = [
        "e4000", "e4001", "e4002", "e4003", "e4004", "e4005", "e4010", "e4011","e4012",
        "e4018", "e4019", "e40110", "e40111", "e40112", "e40113",
        "e4030",
        "e4040", "e4042", "e4043", "e4044", "e4046", "e4047",
        "e4050",
        "e4090", "e4091", "e4040",
        "C003"
    ]
    
    //코드에 따라 유저상태를 분기처리해줘야됨
    // e4041: 프로필생성뷰
    // e4045: 성향테스트스플래시뷰
    // 4015, 4016, 4017: JWT 재발급(리프레시토큰만료 및 오류)
    static let userState = ["e4041", "e4045", "e4015", "e4016", "e4017"]
    
    //토큰재발급해야됨(4013: 카카오, 40111: 애플)
    static let unAuthorized = ["e4013", "e40111"]

    //서버에러
    static let serverErrorCode = "e5000"
}

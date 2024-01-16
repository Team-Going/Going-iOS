//
//  SuccessResponseDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/14/24.
//

import Foundation

//응답값이 s2000으로 올 때, data필요없이 성공여부만 필요할 때 사용, 즉 data가 nil로 들어올 때 사용.
struct BasicResponseDTO: Response, DTO {
    let status: Int
    let code: String
    let message: String
    
}

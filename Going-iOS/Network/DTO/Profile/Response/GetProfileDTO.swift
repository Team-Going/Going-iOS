//
//  GetProfileDTO.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/11/24.
//

import Foundation

// MARK: - DataClass
struct GetProfileDTO: DTO, Response {
    let name, intro: String
    let result: Int
}

extension GetProfileDTO {
    func toUserTypeResult() -> UserTypeTestResultAppData {
        var dummy = UserTypeTestResultAppData.dummy()
        dummy[self.result].userName = self.name
        return dummy[self.result]
    }
}

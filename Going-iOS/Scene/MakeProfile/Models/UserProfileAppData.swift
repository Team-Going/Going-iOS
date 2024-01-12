//
//  UserProfileAppData.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

struct UserProfileAppData: AppData {
    var name: String
    var intro: String
    var platform: String
}

extension UserProfileAppData {
    func toDTOData() -> SignUpRequestDTO {
        return SignUpRequestDTO(name: self.name, intro: self.intro, platform: self.platform)
    }
}

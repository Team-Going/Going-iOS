//
//  JoinTravelTestRequestStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//

import Foundation

// MARK: - JoinTravelTest

struct JoinTravelTestRequestStruct: Request {
    var styleA: Int
    var styleB: Int
    var styleC: Int
    var styleD: Int
    var styleE: Int
}

extension JoinTravelTestRequestStruct {
    func toDTOData() -> JoinTravelTestRequestStruct {
        return JoinTravelTestRequestStruct(styleA: self.styleA, styleB: self.styleB, styleC: self.styleC, styleD: self.styleD, styleE: self.styleE)
    }
}

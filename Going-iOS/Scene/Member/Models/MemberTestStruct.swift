//
//  MemberTestStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/15/24.
//

import UIKit

struct MemberTestStruct {
    let questionIndex: Int
    let questionContent: String
    let optionContent: MemberAnswerStruct
}

struct MemberAnswerStruct {
    let leftOption: String
    let rightOption: String
}

extension MemberTestStruct {
    static let memberTestData: [MemberTestStruct] = [
        MemberTestStruct(questionIndex: 1,
                                 questionContent: "여행 계획",
                                 optionContent: MemberAnswerStruct(leftOption: "철저하게", rightOption: "즉흥으로")),
        MemberTestStruct(questionIndex: 2,
                                 questionContent: "여행 장소",
                                 optionContent: MemberAnswerStruct(leftOption: "관광지", rightOption: "로컬장소")),
        MemberTestStruct(questionIndex: 3,
                                 questionContent: "식당",
                                 optionContent: MemberAnswerStruct(leftOption: "맛집", rightOption: "아무식당")),
        MemberTestStruct(questionIndex: 4,
                                 questionContent: "사진",
                                 optionContent: MemberAnswerStruct(leftOption: "사진필수", rightOption: "눈에 담기")),
        MemberTestStruct(questionIndex: 5,
                                 questionContent: "여행 일정",
                                 optionContent: MemberAnswerStruct(leftOption: "알차게", rightOption: "여유롭게"))
    ]
}

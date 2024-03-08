//
//  MemberTravelTestStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/8/24.
//

import UIKit

struct MemberTravelTestStruct {
    let questionIndex: Int
    let questionContent: String
    let optionContent: MemberTravelTestAnswerStruct
}

struct MemberTravelTestAnswerStruct {
    let leftOption: String
    let middleOption: String
    let rightOption: String
}

extension MemberTravelTestStruct {
    static let memberTestData: [MemberTravelTestStruct] = [
        MemberTravelTestStruct(questionIndex: 1,
                               questionContent: "여행 계획",
                               optionContent: MemberTravelTestAnswerStruct(leftOption: "철저하게",
                                                                           middleOption: "아무렇게",
                                                                           rightOption: "즉흥으로")),
        MemberTravelTestStruct(questionIndex: 2,
                               questionContent: "여행 장소",
                               optionContent: MemberTravelTestAnswerStruct(leftOption: "관광지",
                                                                           middleOption: "어디든",
                                                                           rightOption: "로컬장소")),
        MemberTravelTestStruct(questionIndex: 3,
                               questionContent: "식당",
                               optionContent: MemberTravelTestAnswerStruct(leftOption: "유명 맛집",
                                                                           middleOption: "아무데나",
                                                                           rightOption: "가까운 곳")),
        MemberTravelTestStruct(questionIndex: 4,
                               questionContent: "사진",
                               optionContent: MemberTravelTestAnswerStruct(leftOption: "사진필수",
                                                                           middleOption: "상관없어",
                                                                           rightOption: "눈에 담기")),
        MemberTravelTestStruct(questionIndex: 5,
                               questionContent: "여행 일정",
                               optionContent: MemberTravelTestAnswerStruct(leftOption: "알차게",
                                                                           middleOption: "상관없어",
                                                                           rightOption: "여유롭게"))
    ]
}

//
//  TravelTestQuestionStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/6/24.
//

import UIKit

struct TravelTestQuestionStruct {
    let questionIndex: Int
    let questionContent: String
    let optionContent: TravelAnswerStruct
}

struct TravelAnswerStruct {
    let leftOption: String
    let middleOption: String = "상관없어"
    let rightOption: String
}

extension TravelTestQuestionStruct {
    static let travelTestDummy: [TravelTestQuestionStruct] = [
        TravelTestQuestionStruct(questionIndex: 1,
                                 questionContent: "계획은 어느 정도로 짤까요?",
                                 optionContent: TravelAnswerStruct(leftOption: "철저하게", rightOption: "즉흥으로")),
        TravelTestQuestionStruct(questionIndex: 2,
                                 questionContent: "장소 선택의 기준은 뭔가요?",
                                 optionContent: TravelAnswerStruct(leftOption: "관광지", rightOption: "로컬장소")),
        TravelTestQuestionStruct(questionIndex: 3,
                                 questionContent: "어떤 식당을 갈까요?",
                                 optionContent: TravelAnswerStruct(leftOption: "맛집", rightOption: "아무식당")),
        TravelTestQuestionStruct(questionIndex: 4, 
                                 questionContent: "기억하고 싶은 순간에!",
                                 optionContent: TravelAnswerStruct(leftOption: "사진필수", rightOption: "눈에 담기")),
        TravelTestQuestionStruct(questionIndex: 5,
                                 questionContent: "하루 일정을 어떻게 채우나요?",
                                 optionContent: TravelAnswerStruct(leftOption: "알차게", rightOption: "여유롭게"))
    ]
}

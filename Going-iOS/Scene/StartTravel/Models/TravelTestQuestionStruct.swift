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
                                 questionContent: "계획은 얼만큼 짤까요?",
                                 optionContent: TravelAnswerStruct(leftOption: "철저하게", rightOption: "즉흥으로")),
        TravelTestQuestionStruct(questionIndex: 2,
                                 questionContent: "장소선택의 기준은 뭔가요?",
                                 optionContent: TravelAnswerStruct(leftOption: "관광지", rightOption: "로컬장소")),
        TravelTestQuestionStruct(questionIndex: 3,
                                 questionContent: "어느 식당을 갈까요?",
                                 optionContent: TravelAnswerStruct(leftOption: "맛집", rightOption: "아무식당")),
        TravelTestQuestionStruct(questionIndex: 4, 
                                 questionContent: "멋진 풍경이 보이면?",
                                 optionContent: TravelAnswerStruct(leftOption: "사진필수", rightOption: "눈에 담기")),
        TravelTestQuestionStruct(questionIndex: 5,
                                 questionContent: "스케줄 구성은 어떻게 할끼요?",
                                 optionContent: TravelAnswerStruct(leftOption: "알차게", rightOption: "여유롭게"))
    ]
}

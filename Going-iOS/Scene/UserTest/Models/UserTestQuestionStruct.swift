//
//  UserTestQuestionStruct.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/5/24.
//

import UIKit

struct UserTestQuestionStruct {
    let testIndex: Int
    let testTitle: String
    let testText: UserTestText
}

struct UserTestText {
    let firstQuest: String
    let secondQuest: String
    let thirdQuest: String
    let fourthQuest: String
}

extension UserTestQuestionStruct {
    static func dummy() -> [UserTestQuestionStruct] {
        return [
            UserTestQuestionStruct(testIndex: 1, testTitle: "질문1", testText: UserTestText(firstQuest: "1-1", secondQuest: "1-2", thirdQuest: "1-3", fourthQuest: "1-4")),
            UserTestQuestionStruct(testIndex: 2, testTitle: "질문2", testText: UserTestText(firstQuest: "2-1", secondQuest: "2-2", thirdQuest: "2-3", fourthQuest: "2-4")),
            UserTestQuestionStruct(testIndex: 3, testTitle: "질문3", testText: UserTestText(firstQuest: "3-1", secondQuest: "3-2", thirdQuest: "3-3", fourthQuest: "3-4")),
            UserTestQuestionStruct(testIndex: 4, testTitle: "질문4", testText: UserTestText(firstQuest: "4-1", secondQuest: "4-2", thirdQuest: "4-3", fourthQuest: "4-4")),
            UserTestQuestionStruct(testIndex: 5, testTitle: "질문5", testText: UserTestText(firstQuest: "5-1", secondQuest: "5-2", thirdQuest: "5-3", fourthQuest: "5-4")),
            UserTestQuestionStruct(testIndex: 6, testTitle: "질문6", testText: UserTestText(firstQuest: "6-1", secondQuest: "6-2", thirdQuest: "6-3", fourthQuest: "6-4")),
            UserTestQuestionStruct(testIndex: 7, testTitle: "질문7", testText: UserTestText(firstQuest: "7-1", secondQuest: "7-2", thirdQuest: "7-3", fourthQuest: "7-4")),
            UserTestQuestionStruct(testIndex: 8, testTitle: "질문8", testText: UserTestText(firstQuest: "8-1", secondQuest: "8-2", thirdQuest: "8-3", fourthQuest: "8-4")),
            UserTestQuestionStruct(testIndex: 9, testTitle: "질문9", testText: UserTestText(firstQuest: "9-1", secondQuest: "9-2", thirdQuest: "9-3", fourthQuest: "9-4"))
        ]
    }
}

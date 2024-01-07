////
////  UserTypeTestResultAppData.swift
////  Going-iOS
////
////  Created by 곽성준 on 1/7/24.
////
//
//import Foundation
//
//struct UserTypeTestResultAppData {
//    let userType: String
//    let userTypeDesc: String
//    let userTypeTag: [UserTypeTags]
//    let likePoint: [UserTypePoint]
//    let warningPoint: [UserTypePoint]
//    let goodPoint: [UserTypePoint]
//}
//
//struct UserTypeTags {
//    let firstTag: String
//    let secondTag: String
//    let thirdTag: String
//}
//
//struct UserTypePoint {
//    let firstPoint: String
//    let secondPoint: String
//    let thirdPoint: String
//}
//
//extension UserTypeTestResultAppData {
//    static func dummy() -> [UserTypeTestResultAppData] {
//        return [
//            .init(userType: "배려심 많은 인간 플래너", userTypeDesc: "꼼꼼하고 세심하게 여행을 준비하는 친구", userTypeTag: [UserTypeTags(firstTag: "친구중심", secondTag: "꼼꼼함", thirdTag: "세심함")], likePoint: [UserTypePoint(firstPoint: "같이 가는 친구들을 잘 챙기고 배려해요", secondPoint: "친구들의 의견을 잘 반영해 만족할 수 있는 일정을 계획해요", thirdPoint: "꼼꼼하고 부지런해 맡은 일에서 실수가 적어요")], warningPoint: [UserTypePoint(firstPoint: "완벽주의 성향이 강해 계획이 틀어졌을 때 예민해질 수 있어요", secondPoint: "친구들 간 갈등의 조짐이 보이면 많은 스트레스를 받는 편이에요", thirdPoint: "예기치 않은 상황에서 크게 당황하기도 해요")], goodPoint: [UserTypePoint(firstPoint: "", secondPoint: <#T##String#>, thirdPoint: <#T##String#>)]),
//            
//                .init(userType: "하고 싶은 것이 많은 예스맨", userTypeDesc: "여행 일정에 대한 불만이 낮은 친구", userTypeTag: [UserTypeTags(firstTag: "실용적", secondTag: "긍정적", thirdTag: "개방적")], likePoint: [UserTypePoint(firstPoint: "전반적으로 일정을 계획하고 수행하는 것에 대한 예민도가 낮아요", secondPoint: "활동적인 경험에 관심이 많아 적극적으로 탐색해요", thirdPoint: "여행에서 문제가 생겼을 때 빠르고 효과적인 방안을 마련하곤 해요")], warningPoint:
//                        [UserTypePoint(firstPoint: "우유부단해 귀가 얇고 결정을 잘 내리지 못하는 편이에요", secondPoint: "하고 싶은 게 있어도 잘 말하지 않아 다른 사람들을 답답하게 하기도 해요", thirdPoint: "약간의 귀차니즘이 있어 중간중간 맡은 일을 잘 하고 있는지 확인 필요해요")], goodPoint: <#T##[UserTypePoint]#>),
//            
//                .init(userType: "꼼꼼한 인간 여행 챗지피티", userTypeDesc: "여행의 A부터 Z까지 구조화하고 관리하는 친구", userTypeTag: [UserTypeTags(firstTag: "원칙주의", secondTag: "효율성", thirdTag: "기록형")], likePoint: [UserTypePoint(firstPoint: "역할이 주어졌을 때 완벽하게 해내요", secondPoint: "효율성을 중요시해 지출을 꼼꼼하게 관리해요", thirdPoint: "여행지의 역사, 날씨, 최근 이슈 등까지 세세하고 찾아보고 알려줘요")], warningPoint: [UserTypePoint(firstPoint: "신중하지 못한 행동, 시간 약속을 지키지 못하는 것 등을 싫어해요", secondPoint: "여행 일정에 차질이 생기면 스트레스를 받곤 해요", thirdPoint: "인내심이 있지만 참다가 터질 수 있어요")], goodPoint: <#T##[UserTypePoint]#>),
//            
//                .init(userType: "하고 싶은 것이 명확한 오케이맨", userTypeDesc: "하고 싶은 것 외에는 너그러운 친구", userTypeTag: [UserTypeTags(firstTag: "개인우선", secondTag: "자유로움", thirdTag: "활동중심")], likePoint: [UserTypePoint(firstPoint: "하고 싶은 것만 할 수 있다면 전반적인 여행 일정에서의 포용성이 높아요", secondPoint: "활동 중심의 여행을 선호해 다양한 경험을 함께할 수 있어요", thirdPoint: "예기치 못한 일에도 무난하게 대안을 제시할 수 있어요")], warningPoint: [UserTypePoint(firstPoint: "하고 싶지 않은 일을 강요받으면 여행 자체에 대한 만족도가 크게 떨어져요", secondPoint: "앞장서서 상황을 해결하는 것을 좋아하지 않음", thirdPoint: "혼자만의 시간이 보장되어야 해요")], goodPoint: <#T##[UserTypePoint]#>),
//            
//                .init(userType: "친구들을 잘 챙기는 반장", userTypeDesc: "모두가 즐거운 여행이 되도록 책임지는 친구", userTypeTag: [UserTypeTags(firstTag: "리더십", secondTag: "배려심", thirdTag: "친절함")], likePoint: [UserTypePoint(firstPoint: "여행을 꼼꼼하게 준비하는 편으로 없는 물건, 생각하지 못한 일정이 없어요", secondPoint: "친구에 대한 이해도가 높아 기분을 잘 파악하거나 할일을 적절하게 분배해요", thirdPoint: "친구들을 위해 잘 나서는 타입이에요")], warningPoint: [UserTypePoint(firstPoint: "일정이 원하는대로 되지 않거나 친구들이 다투면 엄청난 스트레스를 받아요", secondPoint: "주도적으로 한 일이 상대방에게 낮은 평가를 받는 경우 큰 상처를 받아요", thirdPoint: "싫은 소리를 하는 것을 두려워 해 불만이 있어도 마음에 쌓아두곤 해요")], goodPoint: <#T##[UserTypePoint]#>),
//            
//                .init(userType: "여행을 100배 즐기는 치어리더", userTypeDesc: "친구들과 함께하는 것에 큰 즐거움을 느끼는 친구", userTypeTag: [UserTypeTags(firstTag: "낙천적", secondTag: "순간기록", thirdTag: "호기심")], likePoint: [UserTypePoint(firstPoint: "사진, 동영상 등으로 여행에서 기록을 많이 남겨요", secondPoint: "함께하는 새로운 경험 자체가 중요하기 때문에 여행의 불만도가 낮아요", thirdPoint: "항상 친구들에게 따뜻하고 응원하는 듯한 태도를 가지고 있어요")], warningPoint: [UserTypePoint(firstPoint: "즉흥적으로 하고 싶은 것이 생겨 기존 계획에 어긋나는 제안을 하곤 해요", secondPoint: "계획을 세우는 행위 자체를 싫어해 중장기 계획을 세우는 데에는 취약해요", thirdPoint: "덜렁거려 평소에 잘 다쳐요")], goodPoint: <#T##[UserTypePoint]#>),
//            
//                .init(userType: "모든 것을 계획하는 인간 총대", userTypeDesc: "후회 없는 여행이 되도록 철두철미하게 계획하는 친구", userTypeTag: [UserTypeTags(firstTag: "주도적", secondTag: "똑부러짐", thirdTag: "준비성")], likePoint: [UserTypePoint(firstPoint: "꼼꼼한 일정 계획으로 알찬 여행을 다녀올 수 있어요", secondPoint: "효율을 추구해 나와 친구가 원하는 곳을 모두 갈 수 있게 일정을 계획해요", thirdPoint: "부당한 일을 겪는 경우, 앞장서서 항의하곤 해요")], warningPoint: [UserTypePoint(firstPoint: "개인이 하고 싶어서 짠 스케줄에 대해 방해받는 것을 싫어해요", secondPoint: "내가 하고 싶은 일을 존중하지 않으면 여행을 잘 가고 싶지 않아해요", thirdPoint: "약간은 냉철하게 이야기하는 편이기도 해요")], goodPoint: <#T##[UserTypePoint]#>),
//            
//                .init(userType: "머릿 속이 상상으로 가득한 작가", userTypeDesc: "궁금한 것도 하고 싶은 것도 많은 호기심 Max 친구", userTypeTag: [UserTypeTags(firstTag: "상상력", secondTag: "호기심", thirdTag: "소심함")], likePoint: [UserTypePoint(firstPoint: "호기심과 도전 정신이 강해 친구들을 새로운 경험으로 이끌 수 있어요", secondPoint: "함께하는 친구들에게 피해를 주거나 민폐가 되지 않기 위해 노력해요", thirdPoint: "유연한 상황 판단과 융툥성 있는 대처로 여행 과정에서의 이슈를 해결해요")], warningPoint: [UserTypePoint(firstPoint: "하고 싶은 일과 하고 싶지 않은 일이 명확해요", secondPoint: "하고 싶은 활동이 함께 여행하는 친구들에게는 매력적이지 않을 수 있어요", thirdPoint: "말하지는 않지만 속으로 수많은 것들을 생각 중일 수 있어요")], goodPoint: <#T##[UserTypePoint]#>)
//            
//        ]
//    }
//}

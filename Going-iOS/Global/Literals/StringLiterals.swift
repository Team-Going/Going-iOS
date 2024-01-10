//
//  StringLiterals.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import Foundation

enum StringLiterals {
    enum Login {
        static let title = "우리만의 여행을 하다"
        static let personalInformation  = " 개인정보처리방침"
    }
    
    enum UserTest {
        static let userTestSplashTitle = "9개의 질문으로\n여행 성향을 분석해보세요 "
    }
  
    enum CreatingSuccess {
        static let title = "새로운 여행이 생성되었어요!"
        static let inviteCodeTitle = "친구 초대코드"
        static let copyCode = " 초대코드 복사하기"
    }
    
    enum JoiningSuccess {
        static let title = "멋진 여행에 초대받으셨네요!"
    }
    
    enum JoinTravel {
        static let inviteCodeTitle = "초대코드"
        static let placeHolder = "초대코드를 입력해주세요."
    }
    
    enum CreateTravel {
        static let namePlaceHolder = "여행 이름을 입력해주세요."
        static let warning = "여행 이름을 입력해주세요."
    }
    
    enum StartTravel {
        static let startTravelTitle = "doorip으로\n모두가 함께 하는 여행!"
    }
    
    enum Settings {
        static let myProfile = "내 프로필"
        static let inquiry = "문의하기"
        static let serviceVersion = "서비스 버전"
        static let policy = "약관 및 정책"
        static let aboutService = "About doorip"
        static let logout = "로그아웃"
    }
}

//
//  StringLiterals.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/1/24.
//

import Foundation

enum StringLiterals {
    enum Login {
        static let title = "우리다운 여행을 하다"
        static let personalInformation  = " 개인정보처리방침"
    }
    
    enum UserTest {
        static let userTestSplashTitle = "여행을 할 때 우리는 어떤 모습일까?"
        static let userTestSplashSubTitle = "9개의 질문으로 \n나를 대신할 여행 캐릭터를 찾아보세요"
    }
  
    enum CreatingSuccess {
        static let title = "새로운 여행을 만들었어요!"
        static let copyCode = " 초대코드 복사하기"
        static let kakaoBtn = "친구에게 초대 코드 보내기"
        static let entranceBtn = "바로 여행 시작하기"
    }
    
    enum JoiningSuccess {
        static let title = "초대받은 여행이 맞는지\n확인해 주세요"
        static let confirmButton = "초대받은 여행이 맞아요!"
    }
    
    enum JoinTravel {
        static let inviteCodeTitle = "초대코드"
        static let placeHolder = "친구에게 받은 초대 코드 6자리를 입력해 주세요"
    }
    
    enum CreateTravel {
        static let namePlaceHolder = "이번 여행의 이름을 지어주세요"
        static let warning = "여행 이름을 입력해 주세요"
        static let nameTitle = "새로운 여행 만들기"
        static let dateTitle = "여행 일정을 알려주세요"
    }
    
    enum StartTravel {
        static let startTravelTitle = "doorip으로\n모두가 함께 하는 여행!"
    }
    
    enum Settings {
        static let myProfile = "여행 프로필"
        static let inquiry = "문의하기"
        static let serviceVersion = "서비스 버전"
        static let policy = "서비스이용약관"
        static let privacy = "개인정보처리방침"
        static let aboutService = "About doorip"
        static let logout = "로그아웃"
    }
    
    enum OurToDo {
        static let ourProgress = "우리 여행 진행률"
        static let friends = "함께 하는 친구들"
        static let invite = "초대"
        static let incomplete = "해야 해요"
        static let complete = "완료했어요"
        static let ourtodo = "같이 할일  "
        static let pleaseAddToDo = "할일을 추가해 보세요"
    }
    
    enum MyToDo {
        static let mytodo = "혼자 할일  "
    }
    
    enum ToDo {
        static let add = "추가"
        static let edit = "수정"
        static let delete = "삭제"
        static let inquiry = "조회"
        static let save = "저장"
        static let toSave = "저장하기"
        static let toEdit = "수정하기"
        static let toDelete = "삭제하기"
        static let todo = "어떤 할일인가요?"
        static let deadline = "언제까지 해야 하나요?"
        static let allocation = "누가 하나요?"
        static let memo = "메모"
        static let addToDo = "할일 추가"
        static let inquiryToDo = "할일 조회"
    }
}

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
        static let startTravelTitle = "여행을 시작해보세요."
    }
    
    enum Settings {
        static let myProfile = "내 프로필"
        static let inquiry = "문의하기"
        static let serviceVersion = "서비스 버전"
        static let policy = "약관 및 정책"
        static let aboutService = "About doorip"
        static let logout = "로그아웃"
    }
    
    enum OurToDo {
        static let ourProgress = "우리 여행 진행률"
        static let friends = "함께 하는 친구들"
        static let invite = "초대"
        static let incomplete = "해야 해요"
        static let complete = "완료했어요"
        static let ourtodo = "같이 할일 "
        static let pleaseAddToDo = "할일을 추가해 보세요"
    }
    
    enum MyToDo {
        static let mytodo = "혼자 할일 "
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

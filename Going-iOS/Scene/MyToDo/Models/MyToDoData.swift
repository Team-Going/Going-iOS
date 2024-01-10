//
//  MyToDoData.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/7/24.
//

import Foundation

struct MyToDoData: Hashable {
    let tripTitle: String
    let toDoCountLabel: String
    let friends: [String]
    let myToDo: [MyToDo]
    
    static var myToDoData: MyToDoData =
        .init(
            tripTitle: "지민이랑 스페인",
            toDoCountLabel: "할일이 0개 남았어요",
            friends: ["지민", "영서", "아린", "현진", "성준", "희슬"],
            myToDo: MyToDo.myToDo
        )
}

struct MyToDo: Hashable {
    let id = UUID()
    let todoTitle: String
    let manager: [String]
    let deadline: String
    var isComplete: Bool
    let isPrivate: Bool
    
    init(todoTitle: String, manager: [String], deadline: String, isComplete: Bool, isPrivate: Bool) {
        self.todoTitle = todoTitle
        self.manager = manager
        self.deadline = deadline
        self.isComplete = isComplete
        self.isPrivate = isPrivate
    }
    
    static var emptyMyToDo: MyToDo = .init(todoTitle: "", manager: [], deadline: "", isComplete: false, isPrivate: false)
    
    static var myToDo: [MyToDo] =
    [
        .init(todoTitle: "지민", manager: ["지민"], deadline: "2023.09.23", isComplete: false, isPrivate: true),
        .init (todoTitle: "아린 현진 완", manager: ["아린", "현진"], deadline: "2023.09.21", isComplete: true, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준", manager: ["성준"], deadline: "2023.09.29", isComplete: false, isPrivate: false),
        .init(todoTitle: "희슬 영서", manager: ["희슬", "영서"], deadline: "2023.09.23", isComplete: false, isPrivate: false),
        .init(todoTitle: "지민 희슬 영서 완", manager: ["지민", "희슬", "영서"], deadline: "2023.09.23", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민 완", manager: ["지민"], deadline: "2023.09.23", isComplete: true, isPrivate: true),
        .init(todoTitle: "영서", manager: ["영서"], deadline: "2023.09.25", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.21", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서 완", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민", manager: ["지민"], deadline: "2023.09.23", isComplete: false, isPrivate: false),
        .init (todoTitle: "아린 현진 완", manager: ["아린", "현진"], deadline: "2023.09.21", isComplete: true, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준", manager: ["성준"], deadline: "2023.09.29", isComplete: false, isPrivate: false),
        .init(todoTitle: "희슬 영서", manager: ["희슬", "영서"], deadline: "2023.09.23", isComplete: false, isPrivate: false),
        .init(todoTitle: "지민 희슬 영서 완", manager: ["지민", "희슬", "영서"], deadline: "2023.09.23", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민 완", manager: ["지민"], deadline: "2023.09.23", isComplete: true, isPrivate: false),
        .init(todoTitle: "영서", manager: ["영서"], deadline: "2023.09.25", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.21", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서 완", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민", manager: ["지민"], deadline: "2023.09.23", isComplete: false, isPrivate: true),
        .init (todoTitle: "아린 현진 완", manager: ["아린", "현진"], deadline: "2023.09.21", isComplete: true, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준", manager: ["성준"], deadline: "2023.09.29", isComplete: false, isPrivate: false),
        .init(todoTitle: "희슬 영서", manager: ["희슬", "영서"], deadline: "2023.09.23", isComplete: false, isPrivate: false),
        .init(todoTitle: "지민 희슬 영서 완", manager: ["지민", "희슬", "영서"], deadline: "2023.09.23", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민 완", manager: ["지민"], deadline: "2023.09.23", isComplete: true, isPrivate: true),
        .init(todoTitle: "영서", manager: ["영서"], deadline: "2023.09.25", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.21", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서 완", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민", manager: ["지민"], deadline: "2023.09.23", isComplete: false, isPrivate: false),
        .init (todoTitle: "아린 현진 완", manager: ["아린", "현진"], deadline: "2023.09.21", isComplete: true, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준", manager: ["성준"], deadline: "2023.09.29", isComplete: false, isPrivate: false),
        .init(todoTitle: "희슬 영서", manager: ["희슬", "영서"], deadline: "2023.09.23", isComplete: false, isPrivate: false),
        .init(todoTitle: "지민 희슬 영서 완", manager: ["지민", "희슬", "영서"], deadline: "2023.09.23", isComplete: true, isPrivate: false),
        .init(todoTitle: "지민 완", manager: ["지민"], deadline: "2023.09.23", isComplete: true, isPrivate: false),
        .init(todoTitle: "영서", manager: ["영서"], deadline: "2023.09.25", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.21", isComplete: false, isPrivate: false),
        .init(todoTitle: "성준 희슬 영서 완", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: true, isPrivate: false),
    ]
}

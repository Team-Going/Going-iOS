//
//  ToDo.swift
//  going_practice
//
//  Created by 윤희슬 on 12/31/23.
//

import Foundation

struct ToDoData {
    let todo: String
    let deadline: String
    let manager: [Manager]
    let memo: String
    
    init(todo: String, deadline: String, manager: [Manager], memo: String) {
        self.todo = todo
        self.deadline = deadline
        self.manager = manager
        self.memo = memo
    }
    
    static var todoData: ToDoData = .init(
        todo: "지민",
        deadline: "2023.09.23",
        manager: [
            Manager.init(name: "지민", isManager: true),
            Manager.init(name: "성준", isManager: false),
            Manager.init(name: "희슬", isManager: false),
            Manager.init(name: "영서", isManager: false),
        ],
        memo: "이것은 메모랍니다. 홍홍홍")
}

struct Manager {
    let name: String
    var isManager: Bool
    
    init(name: String, isManager: Bool) {
        self.name = name
        self.isManager = isManager
    }
}


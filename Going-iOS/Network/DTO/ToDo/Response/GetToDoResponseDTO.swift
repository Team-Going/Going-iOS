//
//  GetToDoResponseDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct GetToDoResponseDTO: DTO, Response {
    let todoId: Int
    let title, endDate: String
    let allocators: [Allocators]
    let secret: Bool
}

struct Allocators: DTO, Response {
    var name: String
    var isOwner: Bool
    
    static let EmptyData = Allocators(name: "나만 볼 수 있는 할일이에요", isOwner: false)
}

extension GetToDoResponseDTO {
    func toAppData() -> ToDoAppData {
        return ToDoAppData(todoId: self.todoId, title: self.title, endDate: self.endDate, allocators: self.allocators, secret: self.secret)
    }
}

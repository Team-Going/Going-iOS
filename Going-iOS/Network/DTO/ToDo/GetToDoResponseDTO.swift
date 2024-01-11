//
//  GetToDoResponseDTO.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct GetToDoResponseDTO: DTO, Response {
    let todoID: Int
    let title, endDate: String
    let allocators: [Allocators]
    let secret: Bool
}

struct Allocators: DTO, Response {
    let name: String
    let isOwner: Bool
}

extension GetToDoResponseDTO {
    func toAppData() -> ToDoAppData {
        return ToDoAppData(todoID: self.todoID, title: self.title, endDate: self.endDate, allocators: self.allocators, secret: self.secret)
    }
}

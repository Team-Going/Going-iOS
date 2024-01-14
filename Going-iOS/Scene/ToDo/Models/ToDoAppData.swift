//
//  ToDoAppData.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct ToDoAppData: AppData {
    let todoId: Int
    let title, endDate: String
    let allocators: [Allocators]
    let secret: Bool
}

extension ToDoAppData {
    static var EmptyData = ToDoAppData(todoId: 0, title: "", endDate: "", allocators: [], secret: false)
}

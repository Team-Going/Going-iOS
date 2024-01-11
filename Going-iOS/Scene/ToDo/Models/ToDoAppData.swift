//
//  ToDoAppData.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct ToDoAppData: AppData {
    let todoID: Int
    let title, endDate: String
    let allocators: [Allocators]
    let secret: Bool
}

extension ToDoAppData {
    static var EmptyData = ToDoAppData(todoID: 0, title: "", endDate: "", allocators: [], secret: false)
    
    static func dummy() -> [ToDoAppData] {
        return [
            .init(todoID: 1,
                  title: "할일1",
                  endDate: "2024.01.02",
                  allocators: [
                    .init(name: "희슬", isOwner: true),
                    .init(name: "희슬1", isOwner: false),
                    .init(name: "희슬2", isOwner: false),
                    .init(name: "희슬3", isOwner: false),
                  ],
                  secret: false),
            .init(todoID: 2,
                  title: "할일2",
                  endDate: "2024.01.02",
                  allocators: [
                    .init(name: "희슬", isOwner: true),
                  ],
                  secret: true),
            .init(todoID: 3,
                  title: "할일3",
                  endDate: "2024.01.02",
                  allocators: [
                    .init(name: "희슬", isOwner: true),
                    .init(name: "희슬1", isOwner: false),
                    .init(name: "희슬2", isOwner: false),
                  ],
                  secret: false),
            .init(todoID: 4,
                  title: "할일4",
                  endDate: "2024.01.02",
                  allocators: [
                    .init(name: "희슬0", isOwner: false),
                    .init(name: "희슬1", isOwner: false),
                    .init(name: "희슬2", isOwner: false),
                    .init(name: "희슬3", isOwner: false),
                  ],
                  secret: false),
            .init(todoID: 5,
                  title: "할일5",
                  endDate: "2024.01.02",
                  allocators: [
                    .init(name: "희슬4", isOwner: false),
                    .init(name: "희슬1", isOwner: false),
                    .init(name: "희슬2", isOwner: false),
                    .init(name: "희슬3", isOwner: false),
                  ],
                  secret: false),
            .init(todoID: 6,
                  title: "할일6",
                  endDate: "2024.01.02",
                  allocators: [
                    .init(name: "희슬6", isOwner: false),
                  ],
                  secret: true),
        ]
    }
}

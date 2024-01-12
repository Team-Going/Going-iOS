//
//  DetailToDoAppData.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/12/24.
//

import Foundation

struct DetailToDoAppData: AppData {
    let title, endDate: String
    let allocators: [Allocators]
    let memo: String
    let secret: Bool
}

extension DetailToDoAppData {
    static var EmptyData = DetailToDoAppData(title: "", endDate: "", allocators: [], memo: "", secret: false)
    
    static func dummy() -> DetailToDoAppData {
        return .init(
            title: "할일1",
            endDate: "2024.01.02",
            allocators: [
                .init(name: "희슬", isOwner: true),
                .init(name: "희슬1", isOwner: false),
                .init(name: "희슬2", isOwner: false),
                .init(name: "희슬3", isOwner: false),
            ],
            memo: "매모지롱ㅋㅋ", 
            secret: true)
    }
}

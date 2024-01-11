//
//  MyToHeaderAppData.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/11/24.
//

import Foundation

struct MyToDoHeaderAppData: AppData {
    let name: String
    let count: Int
}

extension MyToDoHeaderAppData {
    static var EmptyData = MyToDoHeaderAppData(name: "", count: 0)
    
    static func dummy() -> MyToDoHeaderAppData {
        return .init(name: "희슬이랑 파리", count: 1)
    }
}

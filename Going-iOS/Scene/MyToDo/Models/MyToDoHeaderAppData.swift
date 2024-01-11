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
}

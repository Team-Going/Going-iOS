//
//  CreateTravelStruct.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/10/24.
//

import UIKit

struct CreateTravelStruct {
    let travelId: Int
    let travelTitle: String
    let startDate: String
    let endDate: String
    let inviteCode: String
    let dueDate: Int
}

extension CreateTravelStruct {
    static let createTravelDummy : CreateTravelStruct =
        CreateTravelStruct(travelId: 1, travelTitle: "두릅이랑 스페인 여행", startDate: "2023-12-31", endDate: "2024-01-11", inviteCode: "1D3F22", dueDate: 5)
    
}

extension CreateTravelStruct {
    var travelDate: String {
        // 날짜 형식을 변경하는 함수
        func convertDateFormat(from dateString: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else { return "" }
            dateFormatter.dateFormat = "yyyy.MM.dd"
            return dateFormatter.string(from: date)
        }
        
        // 시작 날짜와 종료 날짜의 형식 변경
        let formattedStartDate = convertDateFormat(from: startDate)
        let formattedEndDate = convertDateFormat(from: endDate)
        
        return "\(formattedStartDate) - \(formattedEndDate)"
    }
}

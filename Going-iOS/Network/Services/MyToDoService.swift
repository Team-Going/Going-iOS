//
//  MyToDoService.swift
//  Going-iOS
//
//  Created by 윤희슬 on 1/11/24.
//

import UIKit

final class MyToDoService: Serviceable {
    
    static let shared = MyToDoService()
    
    private init() {}
    
    func getMyToDoHeader(tripId: Int) async throws -> MyToDoHeaderAppData {
        
        /// 1. URLRequest 생성
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/my", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        /// 2. 서버통신
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        /// 3. 에러 핸들링
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetMyToDoResponseDTO.self) else {
            return MyToDoHeaderAppData(participantId: 0, title: "", count: 0)
        }
        
        return model.toAppData()
    }
}

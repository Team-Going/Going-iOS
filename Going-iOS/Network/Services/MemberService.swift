//
//  MemberService.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/14/24.
//

import Foundation

class MemberService: Serviceable {
    static let shared = MemberService()
    
    private init() {}
    
    /// 여행 친구 전체 조회 API
    func getMemberInfo(tripId: Int) async throws -> MemberResponseStruct {
        
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/participants", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, 
                                                           decodeType: MemberResponseStruct.self)
        else { return MemberResponseStruct(bestPrefer: [],
                                           participants: [],
                                           styles: []) }
        
        return model
    }
}

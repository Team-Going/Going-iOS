//
//  ProfileService.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/10/24.
//

import UIKit

final class ProfileService: Serviceable {
    static let shared = ProfileService()
    
    private init() {}
    
    /// 여행 프로필 조회 API
    func getTravelProfileInfo(participantId: Int) async throws -> MemberProfileResponseStruct {
        
        let urlRequest = try NetworkRequest(path: "/api/trips/participants/\(participantId)",
                                            httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, 
                                                           decodeType: MemberProfileResponseStruct.self)
        else { return MemberProfileResponseStruct(name: "", 
                                                  intro: "",
                                                  result: 0,
                                                  styleA: 0, 
                                                  styleB: 0,
                                                  styleC: 0,
                                                  styleD: 0,
                                                  styleE: 0,
                                                  isOwner: false)}
        
        return model
    }
}

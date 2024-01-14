//
//  TravelService.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import UIKit

final class TravelService: Serviceable {
    static let shared = TravelService()
    
    private init() {}
    
    func postInviteCode(code: CodeRequestDTO) async throws -> JoiningSuccessAppData {
        let param = code.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        let urlRequest = try NetworkRequest(path: "/api/trips/verify", httpMethod: .post, body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: CodeResponseDTO.self) else { return JoiningSuccessAppData.EmptyData }
        
        return model.toAppData()
    }
    
    //프로필조회 API
    func getProfileInfo() async throws -> GetProfileResponseDTO {
        
        let urlRequest = try NetworkRequest(path: "/api/users/profile", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetProfileResponseDTO.self) else { return GetProfileResponseDTO(name: "", intro: "", result: 0)}
        
        return model
    }
    
}

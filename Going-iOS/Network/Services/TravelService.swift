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
    
    func postCreateTravel(request: CreateTravelRequestDTO) async throws -> CreateTravelResponseAppData {
        let jsonEncoder = JSONEncoder()
        let body = try jsonEncoder.encode(request)
        let urlRequest = try NetworkRequest(path: "/api/trips", httpMethod: .post, body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: CreateTravelResponseDTO.self) else { return CreateTravelResponseAppData.emptyData }

        return model.toAppData()
    }
}

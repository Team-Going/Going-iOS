//
//  TravelDetailService.swift
//  Going-iOS
//
//  Created by 윤영서 on 3/9/24.
//

import Foundation

class TravelDetailService: Serviceable {
    static let shared = TravelDetailService()
    
    private init() {}
    
    /// 여행 정보 조회 API
    func getTravelDetailInfo(tripId: Int) async throws -> TravelDetailResponseStruct {
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: TravelDetailResponseStruct.self) 
        else { return TravelDetailResponseStruct(tripID: 0, 
                                                 title: "",
                                                 startDate: "",
                                                 endDate: "") }
        
        return model
    }
    
    func patchTravelInfo(tripId: Int, requestBody: EditTravelRequestStruct) async throws {
        let requestData = requestBody.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: requestData)
        
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)", 
                                            httpMethod: .patch,
                                            body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: BasicResponseDTO.self)
    }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: BasicResponseDTO.self)
    }
}

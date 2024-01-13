//
//  OnBoardingService.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/14/24.
//

import Foundation

final class OnBoardingService: Serviceable {
    
    static let shared = OnBoardingService()
    private init() {}
    
    func travelTypeTest(requestDTO: TravelTypeTestRequestDTO) async throws {
        
        let param = requestDTO.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/api/users/test",
                                            httpMethod: .patch,
                                            body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: SuccessResponseDTO.self) else { throw NetworkError.jsonDecodingError }
        
        
        
    }
    
}

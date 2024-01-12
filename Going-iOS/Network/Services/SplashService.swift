//
//  SplashService.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import Foundation

final class SplashService: Serviceable {
    
    static let shared = SplashService()
    private init() {}
    
    func getSplashInfo() async throws {
        
        let urlRequest = try NetworkRequest(path: "/api/users/splash", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: SplashResponseDTO.self) 
            
    }
}



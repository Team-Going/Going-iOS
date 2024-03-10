//
//  ProfileService.swift
//  Going-iOS
//
//  Created by 곽성준 on 3/11/24.
//

import UIKit

final class ProfileService: Serviceable {
    
    static let shared = ProfileService()
    
    private init() {}
    
    func patchMyProfileData(myProfileData: ChangeMyProfileDTO) async throws {
        
        let myProfileInfo: ChangeMyProfileDTO = myProfileData
        let param = myProfileInfo.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/api/users/profile",
                                            httpMethod: .patch,
                                            body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: BasicResponseDTO.self) else { throw NetworkError.jsonDecodingError }
        
    }
}

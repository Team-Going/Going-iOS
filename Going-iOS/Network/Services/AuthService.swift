//
//  AuthService.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/12/24.
//

import UIKit

final class AuthService: Serviceable {
    
    static let shared = AuthService()
    
    private init() {}
    
    func postLogin(token: String, platform: SocialPlatform) async throws -> Bool {
        
        let platformDTO = LoginRequestDTO(platform: platform.rawValue)
        let param = platformDTO.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/api/users/signin", httpMethod: .post, body: body, token: token).makeURLRequest(networkType: .withSocialToken)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: LoginResponseDTO.self) else { throw NetworkError.jsonDecodingError }
        
        let access = model.accessToken
        let refresh = model.refreshToken
        let isToDashBoardView = model.isResult
        
        //UserDefaults에 jwt토큰 저장
        UserDefaults.standard.set(access, forKey: UserDefaultToken.accessToken.rawValue)
        UserDefaults.standard.set(refresh, forKey: UserDefaultToken.refreshToken.rawValue)
    
        // true면 LoginVC에서 대시보드뷰로 이동
        // false면 LoginVC에서 성향테스트스플래시뷰로 이동
        if isToDashBoardView {
            return true
        } else {
            return false
        }
    }
    
    func postSignUp(token: String, signUpBody: SignUpRequestDTO) async throws {
        
        let signUpDTO = signUpBody
        let param = signUpDTO.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/api/users/signup", 
                                            httpMethod: .post,
                                            body: body,
                                            token: token).makeURLRequest(networkType: .withSocialToken)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: SignUpResponseDTO.self) else { throw NetworkError.jsonDecodingError }
        
        let access = model.accessToken
        let refresh = model.refreshToken
        
        //UserDefaults에 jwt토큰 저장
        UserDefaults.standard.set(access, forKey: UserDefaultToken.accessToken.rawValue)
        UserDefaults.standard.set(refresh, forKey: UserDefaultToken.refreshToken.rawValue)
        
        print("회원가입성공!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
    
    func patchLogout() async throws {
        
        let urlRequest = try NetworkRequest(path: "/api/users/signout", httpMethod: .patch).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: LogoutResponseDTO.self)


    }
    
    
}

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
        let userId = model.userId
        
        //UserDefaults에 jwt토큰 저장
        UserDefaults.standard.set(access, forKey: UserDefaultToken.accessToken.rawValue)
        UserDefaults.standard.set(refresh, forKey: UserDefaultToken.refreshToken.rawValue)
        UserDefaults.standard.set(userId, forKey: UserIdDefaults.userID.rawValue)
        
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
        let userId = model.userId
        
        //UserDefaults에 jwt토큰 저장, userId 저장(refresh할 때 필요)
        UserDefaults.standard.set(access, forKey: UserDefaultToken.accessToken.rawValue)
        UserDefaults.standard.set(refresh, forKey: UserDefaultToken.refreshToken.rawValue)
        UserDefaults.standard.set(userId, forKey: UserIdDefaults.userID.rawValue)
    }
    
    func patchLogout() async throws {
        
        let urlRequest = try NetworkRequest(path: "/api/users/signout", httpMethod: .patch).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: LogoutResponseDTO.self)
    }
    
    func deleteUserInfo() async throws {
        
        let urlRequest = try NetworkRequest(path: "/api/users/withdraw", httpMethod: .delete).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: BasicResponseDTO.self)
        
        UserDefaults.standard.removeObject(forKey: UserIdDefaults.userID.rawValue)

    }
    
    func postReIssueJWTToken() async throws {
        let userID = UserDefaults.standard.integer(forKey: UserIdDefaults.userID.rawValue)
        let param = ReIssueJWTRequsetDTO(userId: userID).toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        let urlRequest = try NetworkRequest(path: "/api/users/reissue", httpMethod: .post, body: body).makeURLRequest(networkType: .withRefresh)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: SignUpResponseDTO.self) else {
            return
        }
        
        let access = model.accessToken
        let refresh = model.refreshToken
        
        //UserDefaults에 jwt토큰 저장
        UserDefaults.standard.set(access, forKey: UserDefaultToken.accessToken.rawValue)
        UserDefaults.standard.set(refresh, forKey: UserDefaultToken.refreshToken.rawValue)
    }
}

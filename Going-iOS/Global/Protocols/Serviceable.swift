//
//  Serviceable.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

/// 서비스 객체에서 필수로 채택해줘야 하는 프로토콜
protocol Serviceable {
    /// 네트워크 통신 중 생긴 에러를 우리가 만든 에러모델로 던지는 메서드
    /// - Parameters:
    ///   - data: Data타입의 통신 결과
    ///   - decodeType: Data타입의 통신결과를 해당 타입으로 decode
    func dataDecodeAndhandleErrorCode<T: Response>(data: Data, decodeType: T.Type) throws -> T?
}

extension Serviceable {
    @discardableResult
    func dataDecodeAndhandleErrorCode<T: Response>(data: Data, decodeType: T.Type) throws -> T? {

        guard let model = try? JSONDecoder().decode(BaseResponse<T>.self, from: data) else {
            throw NetworkError.jsonDecodingError
        }
        
        print("✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨")
       
        let code = model.code
        let message = model.message
                
        guard !NetworkErrorCode.clientErrorCode.contains(code) else {
            throw NetworkError.clientError(message: message)
        }
        
        guard !NetworkErrorCode.userState.contains(code) else {
            throw NetworkError.userState(code: code, message: message)
        }
        
        //로그인으로
        guard !NetworkErrorCode.unAuthorized.contains(code) else {
            throw NetworkError.unAuthorizedError
        }
        
        //그 뷰에서 JWT재발급
        guard !NetworkErrorCode.reIssueJWT.contains(code) else {
            throw NetworkError.reIssueJWT
        }
        
        guard !NetworkErrorCode.serverErrorCode.contains(code) else {
            throw NetworkError.serverError
        }

        print("✅API호출성공✅")
        return model.data
    }
}

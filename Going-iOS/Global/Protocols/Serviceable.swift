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
       
        let code = model.code
        let message = model.message
        
        //4041일때는 프로필 생성뷰로
        //4045일때는 성향테스트스플래시뷰로
//        if code == "e4041" || code == "e4045"{
//            throw NetworkError.userState(code: code, message: message)
        
        if code == "e4041" || code == "e4045" {
            throw NetworkError.userState(code: code)
        }

        if code != "s2000" {
            throw NetworkError.userState(code: code)
        }
//        let statusCode = model.code
//        guard !NetworkErrorCode.clientErrorCode.contains(statusCode) else {
//            throw NetworkError.clientError(code: model.code, message: model.message)
//        }
//
//        guard !NetworkErrorCode.serverErrorCode.contains(statusCode) else {
//            throw NetworkError.serverError
//        }
        print("✅✅✅✅✅✅✅✅✅✅✅✅✅원래 API호출성공✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅")
        return model.data
    }
}

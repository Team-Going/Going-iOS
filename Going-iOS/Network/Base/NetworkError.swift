//
//  NetworkError.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

@frozen
enum NetworkError: Error, CustomStringConvertible {
    case urlEncodingError
    case jsonDecodingError
    case fetchImageError
    case clientError(code: String, message: String)
    case serverError
    case unAuthorizedError
    case userState(code: String, message: String)
    case reIssueJWT
    
    var description: String {
        switch self {
        case .urlEncodingError:
            return "🔒URL Encoding 에러입니다"
        case .jsonDecodingError:
            return "🔐JSON Decoding 에러입니다"
        case .fetchImageError:
            return "🌄Image URL로부터 불러오기 실패"
        case .clientError(let code, let message):
            return "📱클라이언트 에러 code: \(code), message:\(message)"
        case .serverError:
            return "🖥️서버 에러"
        case .userState(let code, let message):
            return "code: \(code), userState: \(message)"
        case .unAuthorizedError:
            return "🚪 접근 권한이 없습니다 (토큰 만료)"
        case .reIssueJWT:
            return "JWT토큰을 재발급받으세요"
        }
    }
}

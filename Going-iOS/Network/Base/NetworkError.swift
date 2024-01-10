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
    case clientError(message: String)
    case serverError
    
    var description: String {
        switch self {
        case .urlEncodingError:
            return "🔒URL Encoding 에러입니다"
        case .jsonDecodingError:
            return "🔐JSON Decoding 에러입니다"
        case .fetchImageError:
            return "🌄Image URL로부터 불러오기 실패"
        case .clientError(let message):
            return "📱클라이언트 에러 : \(message)"
        case .serverError:
            return "🖥️서버 에러"
        }
    }
}

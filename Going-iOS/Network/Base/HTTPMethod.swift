//
//  HTTPMethod.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import UIKit

enum HttpMethod: String {
    case get
    case post
    case put
    case patch
    case delete

    var rawValue: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        }
    }
}

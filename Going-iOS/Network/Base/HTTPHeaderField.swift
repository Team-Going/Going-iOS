//
//  HTTPHeaderField.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case authentication = "Authorization"
}

enum ContentType: String {
    case json = "Application/json"
}

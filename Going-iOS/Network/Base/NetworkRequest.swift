//
//  NetworkRequest.swift
//  Going-iOS
//
//  Created by 곽성준 on 1/10/24.
//

import Foundation

struct NetworkRequest {
    let path: String
    let httpMethod: HttpMethod
    let query: Request?
    let body: Data?
    let header: [String: String]?
    let token: String?

    init(path: String, httpMethod: HttpMethod, query: Request? = nil, body: Data? = nil, header: [String : String]? = nil, token: String? = "") {
        self.path = path
        self.httpMethod = httpMethod
        self.query = query
        self.body = body
        self.header = header
        self.token = token
    }

    func makeURLRequest(networkType: LoginType) throws -> URLRequest {
        var urlComponents = URLComponents(string: Config.baseURL)

        //Service객체에서 바디나 쿼리가 필요하면 아래와 같이 사용
        //1. 쿼리에 들어갈 것을 바로 딕셔너리로 넣어주는 것이 아니라,
        //구조체를 만들어두고 toDictionary()를 활용해서 딕셔너리로 변환시켜주고 쿼리에 넣어준다
        //아래와 같은 구조체를 선언해두고, NetworkRequest(여기에 넣어주고 값만 설정해준다.)
//        struct queryStruct: Codable {
//            let name: String
//            let age: Int
//        }
        
        if let query = self.query {
            let queries = query.toDictionary()
            let queryItemArray = queries.map {
                return URLQueryItem(name: $0.key, value: "\($0.value)")
            }
            urlComponents?.queryItems = queryItemArray
        }
        
        /// 2. Body에 필요한 정보 DATA로 encode
          /// let params = token.toDictionary()
           ///let body = try JSONSerialization.data(withJSONObject: params, options: [])
       

        guard let urlRequestURL = urlComponents?.url?.appendingPathComponent(self.path) else {
            throw NetworkError.urlEncodingError
        }

        var urlRequest = URLRequest(url: urlRequestURL)
        urlRequest.httpMethod = self.httpMethod.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        switch networkType {
        case .withJWT:
            guard let token = UserDefaults.standard.string(forKey: UserDefaultToken.accessToken.rawValue) else {  throw NetworkError.clientError(message: "AccessToken 없음") }
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
            
        case .withRefresh:
            guard let token = UserDefaults.standard.string(forKey: UserDefaultToken.refreshToken.rawValue) else {  throw NetworkError.clientError(message: "RefreshToken 없음") }
            urlRequest.setValue("\(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
            
        case .withSocialToken:
            guard let token = self.token else { throw NetworkError.clientError(message: "socialToken 없음") }
            urlRequest.setValue("\(token)", forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }
    
        urlRequest.httpBody = self.body

        return urlRequest
    }
}

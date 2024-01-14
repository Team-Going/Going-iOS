//
//  TravelService.swift
//  Going-iOS
//
//  Created by 윤영서 on 1/12/24.
//

import UIKit

final class TravelService: Serviceable {
    static let shared = TravelService()
    
    private init() {}
    
    /// 초대코드 검증 API
    func postInviteCode(code: CodeRequestDTO) async throws -> JoiningSuccessAppData {
        let param = code.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        let urlRequest = try NetworkRequest(path: "/api/trips/verify", httpMethod: .post, body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: CodeResponseDTO.self) 
        else { return JoiningSuccessAppData(travelId: 0, travelName: "", startDate: "", endDate: "", dueDate: 0) }
        
        return model.toAppData()
    }
    
    /// 여행 생성 API
    func postCreateTravel(request: CreateTravelRequestDTO) async throws -> CreateTravelResponseAppData {
        let jsonEncoder = JSONEncoder()
        let body = try jsonEncoder.encode(request)
        let urlRequest = try NetworkRequest(path: "/api/trips",
                                            httpMethod: .post,
                                            body: body).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let model = try dataDecodeAndhandleErrorCode(data: data,
                                                           decodeType: CreateTravelResponseDTO.self) 
        else { return CreateTravelResponseAppData(tripId: 0, title: "", startDate: "", endDate: "", code: "", day: 0) }
        
        return model.toAppData()
    }
    
    /// 여행 전체 조회 API
    func getAllTravel(status: String) async throws -> DashBoardResponseSturct {
        let query = TravelQuery(progress: status)
        let urlRequest = try NetworkRequest(path: "/api/trips",
                                            httpMethod: .get, 
                                            query: query).makeURLRequest(networkType: .withJWT)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let model = try dataDecodeAndhandleErrorCode(data: data,
                                                           decodeType: DashBoardResponseSturct.self) 
        else { return DashBoardResponseSturct(name: "", trips: []) }
        return model
    }
    
    /// 여행 입장 API
    func postJoinTravelTest(request: JoinTravelTestRequestStruct, tripId: Int) async throws -> JoinTravelTestResponseStruct {
        let jsonEncoder = JSONEncoder()
        let body = try jsonEncoder.encode(request)
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/entry",
                                            httpMethod: .post,
                                            body: body).makeURLRequest(networkType: .withJWT)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let model = try dataDecodeAndhandleErrorCode(data: data, 
                                                           decodeType: JoinTravelTestResponseStruct.self) 
        else { return JoinTravelTestResponseStruct(tripId: 0) }
        return model
    }
    
    /// 프로필 조회 API
    func getProfileInfo() async throws -> GetProfileResponseDTO {
        
        let urlRequest = try NetworkRequest(path: "/api/users/profile", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetProfileResponseDTO.self) else { return GetProfileResponseDTO(name: "", intro: "", result: 0)}
        
        return model
    }
}

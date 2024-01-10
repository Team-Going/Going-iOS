////
////  ToDoService.swift
////  Going-iOS
////
////  Created by 곽성준 on 1/11/24.
////
//
//import UIKit
//
//struct Query:  {
//    let category: String
//    let progress: String
//}
//
//struct CreateToDoRequestDTO: DTO, Request {
//    let title: String
//    let endData: String
//    let allocators: [Int]
//    let memo: String?
//    let secret: Bool
//}
//
//protocol Todoserviceprotocol {
//    func getTodoDetail(todoID: Int) async throws -> UserPlaceAppData
//}
//
//final class ToDoService: Serviceable, Todoserviceprotocol {
//    
//
//    
//    func getTodoDetail(todoID: Int) async throws -> UserPlaceAppData {
//        
//        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoID)", httpMethod: .get).makeURLRequest()
//        
//        let (data, _) = try await URLSession.shared.data(for: urlRequest)
//        
//        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: TodoDTO.self) else {
//            return TodoAppData.EmptyData
//        }
//        
//        return PlaceMainDTO.toAppData()
//    }
//    
//    
//    
//    func postCreateToDo(createToDoRequset: DTO, tripID: Int) async throws -> 받을 Appdata데이터구조체 {
//        
//        //쿼리 넣을 때(여기서는 필요없는데 예시임)
//        // 이거를 이제 urlRequest query에 그대로 넣으면 됩니다.
//        let queryStruct = Query(category: "ss", progress: "dd") /*여기에 필요한 값 파라미터로 가져와서 넣으셈*/)
//        
//        //바디 넣을 때.
//        //밑의 바디를 urlRequest body에 그대로 넣으면 됩니다. 바디는 아래와 같이 Data 타입으로 변환하고 넣어줘야됨(바디타입이 Data임)
//        let toDoRequest = CreateToDoRequestDTO(title: createToDoRequset.title, endData: createToDoRequset.endData, allocators: createToDoRequset.allocators, memo: createToDoRequset.memo, secret: createToDoRequset.secret)
//        let param = toDoRequest.toDictionary()
//        let body = try JSONSerialization.data(withJSONObject: param)
//
//        //path variable은 링크에 바로 넣어주면 됨
//        //아래 tripID같은거임
//        
//        
////        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripID)/todos)", httpMethod: .get, body: body).makeURLRequest()
//        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripID)/todos", httpMethod: .get, query: query, body: body)
//        
//        
//        let (data, _) = try await URLSession.shared.data(for: urlRequest)
//        
//        
//        
//        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: TodoDTO.self) else {
//            return TodoAppData.EmptyData
//        }
//        
//        return model.appData
//
//        
//    }
//    
//}

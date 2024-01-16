import UIKit

final class ToDoService: Serviceable {
    
    static let shared = ToDoService()
    private init() {}
    
    func getToDoData(tripId: Int, category: String, progress: String) async throws -> [ToDoAppData] {
        let requestDto = GetToDoRequestDTO(category: category, progress: progress)
        
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/todos", httpMethod: .get, query: requestDto).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: [GetToDoResponseDTO].self) else {
            return []
        }
        
        return model.map { $0.toAppData() }
    }
    
    func getDetailToDoData(todoId: Int) async throws -> GetDetailToDoResponseStuct {
        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoId)", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetDetailToDoResponseStuct.self) else {
            return GetDetailToDoResponseStuct(title: "", endDate: "", allocators: [], memo: "", secret: false)
        }
        return model
    }
    
    func getCompleteToDoData(todoId: Int) async throws {
        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoId)/complete", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        print("getCompleteToDoData")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: GetCompleteToDoResponseDTO.self)
    }
    
    func getIncompleteToDoData(todoId: Int) async throws {
        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoId)/incomplete", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        print("getIncompleteToDoData")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        try dataDecodeAndhandleErrorCode(data: data, decodeType: GetCompleteToDoResponseDTO.self)
    }
    
    func postCreateToDo(tripId: Int, requestBody: CreateToDoRequestStruct) async throws {

        let param = requestBody.toDictionary()
        let body = try JSONSerialization.data(withJSONObject: param)
        
        
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/todos", httpMethod: .post, body:  body).makeURLRequest(networkType: .withJWT)
        print("getCompleteToDoData")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: GetCompleteToDoResponseDTO.self)
        
        
    }
    
    func deleteTodo(todoId: Int) async throws {
        
        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoId)", httpMethod: .delete).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: BasicResponseDTO.self)
        
    }
    
    
}

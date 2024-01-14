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
    
    func getDetailToDoData(todoId: Int) async throws -> DetailToDoAppData {
        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoId)", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetDetailToDoResponseDTO.self) else {
            return DetailToDoAppData.EmptyData
        }
        return model.toAppData()
    }
    
    func getCompleteToDoData(todoId: Int) async throws {
        let urlRequest = try NetworkRequest(path: "/api/trips/todos/\(todoId)/complete", httpMethod: .get).makeURLRequest(networkType: .withJWT)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        try dataDecodeAndhandleErrorCode(data: data, decodeType: GetCompleteToDoResponseDTO.self)
    }
}

import UIKit

final class ToDoService: Serviceable {
    static let shared = ToDoService()
    private init() {}
    
    func getToDoData(tripId: Int) async throws -> ToDoAppData {
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/todos", httpMethod: .get).makeURLRequest()
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetToDoResponseDTO.self) else {
            return ToDoAppData.EmptyData
        }
        return model.toAppData()
    }
}

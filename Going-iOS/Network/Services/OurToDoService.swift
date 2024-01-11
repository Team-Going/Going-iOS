import UIKit

final class OurToDoService: Serviceable {
    
    static let shared = OurToDoService()
    
    private init() {}
    
    func getOurToDoHeader(tripId: Int) async throws -> OurToDoHeaderAppData {
        let urlRequest = try NetworkRequest(path: "/api/trips/\(tripId)/our", httpMethod: .get).makeURLRequest()
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: GetOurToDoResponseDTO.self) else { return OurToDoHeaderAppData.EmptyData }
        
        return model.toAppData()
    }
}



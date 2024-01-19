import Foundation

struct DetailToDoAppData: AppData {
    let title, endDate: String
    let allocators: [Allocators]
    let memo: String
    let secret: Bool
}

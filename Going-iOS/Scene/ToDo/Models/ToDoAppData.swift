import Foundation

struct ToDoAppData: AppData {
    let todoId: Int
    let title, endDate: String
    let allocators: [Allocators]
    let secret: Bool
}

import Foundation

struct TaskItem: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var image: String
    var description: String

    enum CodingKeys: String, CodingKey {
        case id, name, image, description
    }
}

// Keep Task as a typealias for compatibility
typealias Task = TaskItem

struct TasksData: Codable {
    var tasks: [TaskItem]
}

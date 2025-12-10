import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var image: String
    var description: String
}

struct TasksData: Codable {
    var tasks: [Task]
}

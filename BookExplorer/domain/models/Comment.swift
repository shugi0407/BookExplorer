import Foundation

struct Comment: Identifiable, Equatable {
    let id: String
    let workId: String
    let userId: String
    let userEmail: String
    let text: String
    let createdAt: Date
}

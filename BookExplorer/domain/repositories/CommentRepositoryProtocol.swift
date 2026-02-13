import Foundation

protocol CommentRepositoryProtocol {
    func addComment(workId: String, text: String, user: UserProfile) async throws
    func deleteComment(workId: String, commentId: String, user: UserProfile) async throws
    func observeComments(workId: String, onChange: @escaping ([Comment]) -> Void)
    func stopObserving()
}

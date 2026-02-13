import Foundation

protocol BookRepositoryProtocol {
    func feed(page: Int, pageSize: Int) async throws -> [Book]
    func search(query: String, page: Int, pageSize: Int) async throws -> [Book]
    func details(workId: String) async throws -> Book

    /// Offline-first access (read cached content).
    func cachedFeed() throws -> [Book]
    func cachedDetails(workId: String) throws -> Book?
}

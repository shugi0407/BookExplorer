import Foundation

protocol FavoriteRepositoryProtocol {
    func isFavorite(workId: String, uid: String) async throws -> Bool
    func setFavorite(workId: String, uid: String, isFavorite: Bool) async throws
    func observeFavorites(uid: String, onChange: @escaping ([String]) -> Void)
    func stopObserving()
}

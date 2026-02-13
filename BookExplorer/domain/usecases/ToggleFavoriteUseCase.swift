import Foundation

struct ToggleFavoriteUseCase {
    let favorites: FavoriteRepositoryProtocol

    func toggle(workId: String, uid: String, makeFavorite: Bool) async throws {
        try await favorites.setFavorite(workId: workId, uid: uid, isFavorite: makeFavorite)
    }
}

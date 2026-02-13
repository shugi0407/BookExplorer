import Foundation

final class DIContainer {
    static let shared = DIContainer()

    // Core infra
    let coreData = CoreDataStack()
    let apiClient = APIClient()
    let firebase = FirebaseManager()

    // Repos
    lazy var authRepo: AuthRepositoryProtocol = AuthRepository(firebase: firebase)
    lazy var favoritesRepo: FavoriteRepositoryProtocol = FavoriteRepository(firebase: firebase)
    lazy var commentRepo: CommentRepositoryProtocol = CommentRepository(firebase: firebase)
    lazy var bookRepo: BookRepositoryProtocol = BookRepository(
        api: apiClient,
        coreData: coreData
    )

    // Use cases
    let scoreBook = ScoreBookUseCase()
    lazy var toggleFavorite = ToggleFavoriteUseCase(favorites: favoritesRepo)

    private init() {}
}

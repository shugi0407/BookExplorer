import Foundation
import Combine


@MainActor
final class ProfileViewModel: ObservableObject {
    private let di = DIContainer.shared

    @Published var favoriteWorkIds: [String] = []

    func start(uid: String) {
        di.favoritesRepo.observeFavorites(uid: uid) { [weak self] ids in
            Task { @MainActor in self?.favoriteWorkIds = ids }
        }
    }

    func stop() {
        di.favoritesRepo.stopObserving()
    }
}

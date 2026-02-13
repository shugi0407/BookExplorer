import Foundation
import Combine


@MainActor
final class DetailViewModel: ObservableObject {
    private let di = DIContainer.shared
    private let tag = "DetailVM"

    @Published var state: LoadState<Book> = .loading
    @Published var book: Book?
    @Published var comments: [Comment] = []
    @Published var isFavorite: Bool = false
    @Published var errorMessage: String?

    private let workId: String

    init(workId: String) {
        self.workId = workId
    }

    func onAppear(user: UserProfile?) async {
        await load(user: user)
        observeComments()
        await refreshFavorite(user: user)
    }

    func onDisappear() {
        di.commentRepo.stopObserving()
    }

    func retry(user: UserProfile?) async {
        await load(user: user)
    }

    func toggleFavorite(user: UserProfile?) async {
        guard let user else { return }
        do {
            try await di.toggleFavorite.toggle(workId: workId, uid: user.uid, makeFavorite: !isFavorite)
            await refreshFavorite(user: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addComment(text: String, user: UserProfile?) async {
        guard let user else { return }
        do {
            try await di.commentRepo.addComment(workId: workId, text: text, user: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteComment(commentId: String, user: UserProfile?) async {
        guard let user else { return }
        do {
            try await di.commentRepo.deleteComment(workId: workId, commentId: commentId, user: user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func load(user: UserProfile?) async {
        state = .loading

        // show cached details quickly if exists
        if let cached = try? di.bookRepo.cachedDetails(workId: workId) {
            book = cached
            state = .loaded(cached)
        }

        do {
            let b = try await withRetry { [self] in
                try await self.di.bookRepo.details(workId: self.workId)
            }

            book = b
            state = .loaded(b)
        } catch {
            Log.e(tag, "details error: \(error)")
            if book == nil {
                state = .failed(error.localizedDescription)
            }
        }
    }

    private func observeComments() {
        di.commentRepo.observeComments(workId: workId) { [weak self] items in
            Task { @MainActor in
                self?.comments = items
            }
        }
    }

    private func refreshFavorite(user: UserProfile?) async {
        guard let user else { return }
        do {
            isFavorite = try await di.favoritesRepo.isFavorite(workId: workId, uid: user.uid)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func withRetry<T>(_ op: @escaping () async throws -> T) async throws -> T {
        do { return try await op() }
        catch {
            try await Task.sleep(nanoseconds: 350_000_000)
            return try await op()
        }
    }
}

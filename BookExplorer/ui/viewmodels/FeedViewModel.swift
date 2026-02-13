import Foundation
import Combine


@MainActor
final class FeedViewModel: ObservableObject {
    private let di = DIContainer.shared
    private let tag = "FeedVM"

    @Published var state: LoadState<[Book]> = .idle
    @Published var books: [Book] = []

    private var page = 1
    private let pageSize = 20
    private var isLoadingMore = false

    func loadInitial() async {
        page = 1
        state = .loading

        // Offline-first: show cache immediately if exists
        if let cached = try? di.bookRepo.cachedFeed(), !cached.isEmpty {
            books = cached
            state = .loaded(cached)
        }

        await fetchPage(reset: true)
    }

    func loadMoreIfNeeded(current book: Book) async {
        guard !isLoadingMore else { return }
        guard let last = books.last, last.id == book.id else { return }
        await fetchPage(reset: false)
    }

    func retry() async { await loadInitial() }

    private func fetchPage(reset: Bool) async {
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let fetched = try await withRetry { [self] in
                try await self.di.bookRepo.feed(page: self.page, pageSize: self.pageSize)
            }


            if reset {
                books = fetched
                state = fetched.isEmpty ? .empty("No books found.") : .loaded(fetched)
            } else {
                if fetched.isEmpty { return }
                books.append(contentsOf: fetched)
                state = .loaded(books)
            }
            page += 1
        } catch {
            Log.e(tag, "feed error: \(error)")
            if books.isEmpty {
                state = .failed(error.localizedDescription)
            }
        }
    }

    // Basic automatic retry + supports manual retry in UI states.
    private func withRetry<T>(_ op: @escaping () async throws -> T) async throws -> T {
        do { return try await op() }
        catch {
            // auto retry once for transient failures
            try await Task.sleep(nanoseconds: 400_000_000)
            return try await op()
        }
    }
}

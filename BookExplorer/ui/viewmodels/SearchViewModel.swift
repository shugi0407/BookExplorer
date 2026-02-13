import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    private let di = DIContainer.shared
    private let tag = "SearchVM"

    @Published var query: String = ""
    @Published var state: LoadState<[Book]> = .idle
    @Published var results: [Book] = []

    private var page = 1
    private let pageSize = 20
    private var searchTask: Task<Void, Never>?
    private var isLoadingMore = false

    func onQueryChanged(_ new: String) {
        query = new
        page = 1
        results = []
        state = .idle

        // Debounced search (required)
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            await self.search(reset: true)
        }
    }

    func loadMoreIfNeeded(current book: Book) async {
        guard !isLoadingMore else { return }
        guard let last = results.last, last.id == book.id else { return }
        await search(reset: false)
    }

    func retry() async {
        await search(reset: true)
    }

    private func search(reset: Bool) async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard q.count >= 2 else {
            state = .empty("Type at least 2 characters.")
            return
        }

        if reset {
            page = 1
            results = []
            state = .loading
        }

        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let fetched = try await withRetry { [self] in
                try await self.di.bookRepo.search(query: q, page: self.page, pageSize: self.pageSize)
            }

            if reset {
                self.results = fetched
            } else {
                self.results.append(contentsOf: fetched)
            }

            self.state = self.results.isEmpty ? .empty("No results.") : .loaded(self.results)
            self.page += 1

        } catch is CancellationError {
            // Normal for debounced searches: user typed again, previous request cancelled.
            return

        } catch {
            Log.e(tag, "search error: \(error)")
            self.state = .failed(error.localizedDescription)
        }
    }

    private func withRetry<T>(_ op: @escaping () async throws -> T) async throws -> T {
        do {
            return try await op()
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            // basic automatic retry once for transient failures
            try await Task.sleep(nanoseconds: 400_000_000)
            return try await op()
        }
    }
}

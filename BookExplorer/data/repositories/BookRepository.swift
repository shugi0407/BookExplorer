import Foundation
import CoreData

final class BookRepository: BookRepositoryProtocol {

    private let api: APIClient
    private let coreData: CoreDataStack
    private let tag = "BookRepository"

    // 24h cache TTL
    private let cacheTTL: TimeInterval = 24 * 60 * 60

    init(api: APIClient, coreData: CoreDataStack) {
        self.api = api
        self.coreData = coreData
    }

    // MARK: - Remote

    func feed(page: Int, pageSize: Int) async throws -> [Book] {
        let dto: SearchResponseDTO = try await api.get(Endpoints.feed(page: page))
        let books = dto.docs.compactMap(mapDocToBook)

        try await cacheBooks(books, kind: "feed")

        return Array(books.prefix(pageSize))
    }

    func search(query: String, page: Int, pageSize: Int) async throws -> [Book] {
        let safe = query.sanitizedQuery
        guard safe.count >= 2 else { return [] }

        let dto: SearchResponseDTO = try await api.get(
            Endpoints.search(q: safe, page: page)
        )

        let books = dto.docs.compactMap(mapDocToBook)

        return Array(books.prefix(pageSize))
    }

    func details(workId: String) async throws -> Book {

        // 1️⃣ Prefer fresh cache
        if let cached = try cachedDetailsMeta(workId: workId),
           isFresh(cached.updatedAt) {
            return cached.book
        }

        // 2️⃣ Otherwise fetch from network
        let base =
            try cachedDetailsMeta(workId: workId)?.book
            ?? Book(
                id: workId,
                title: "Loading…",
                authors: [],
                firstPublishYear: nil,
                coverId: nil,
                description: nil
            )

        let details: WorkDetailsDTO =
            try await api.get(Endpoints.workDetails(workId: workId))

        let desc = details.description?.stringValue

        let merged = Book(
            id: base.id,
            title: base.title,
            authors: base.authors,
            firstPublishYear: base.firstPublishYear,
            coverId: base.coverId,
            description: desc
        )

        try await cacheBooks([merged], kind: "details")

        return merged
    }

    // MARK: - Offline

    func cachedFeed() throws -> [Book] {
        let ctx = coreData.container.viewContext

        let req = NSFetchRequest<BookCacheEntity>(
            entityName: "BookCacheEntity"
        )
        req.predicate = NSPredicate(format: "kind == %@", "feed")
        req.sortDescriptors = [
            NSSortDescriptor(key: "updatedAt", ascending: false)
        ]

        let items = try ctx.fetch(req)
        return items.map { $0.toDomain }
    }

    func cachedDetails(workId: String) throws -> Book? {
        let ctx = coreData.container.viewContext

        let req = NSFetchRequest<BookCacheEntity>(
            entityName: "BookCacheEntity"
        )
        req.predicate = NSPredicate(
            format: "kind == %@ AND id == %@",
            "details",
            workId
        )
        req.fetchLimit = 1

        return try ctx.fetch(req).first?.toDomain
    }

    // MARK: - Cache & Merge Policy

    private func cacheBooks(_ books: [Book], kind: String) async throws {
        let ctx = coreData.newBackgroundContext()

        try await ctx.perform {
            for b in books {

                let req = NSFetchRequest<BookCacheEntity>(
                    entityName: "BookCacheEntity"
                )
                req.predicate = NSPredicate(
                    format: "id == %@ AND kind == %@",
                    b.id,
                    kind
                )
                req.fetchLimit = 1

                let existing = try ctx.fetch(req).first
                let obj = existing ?? BookCacheEntity(context: ctx)

                obj.id = b.id
                obj.kind = kind
                obj.title = b.title
                obj.authors = b.authors
                obj.firstPublishYear = Int32(b.firstPublishYear ?? 0)
                obj.coverId = Int32(b.coverId ?? 0)
                obj.bookDescription = b.description
                obj.updatedAt = Date()
            }

            if ctx.hasChanges {
                try ctx.save()
            }
        }
    }

    private func isFresh(_ date: Date) -> Bool {
        Date().timeIntervalSince(date) < cacheTTL
    }

    // MARK: - DTO → Domain Mapping

    private func mapDocToBook(_ d: DocDTO) -> Book? {
        guard let title = d.title, !title.isEmpty else { return nil }
        guard let rawKey = d.key else { return nil }

        // remove "/works/" prefix safely
        let cleanId = rawKey.replacingOccurrences(of: "/works/", with: "")

        return Book(
            id: cleanId,
            title: title,
            authors: d.author_name ?? [],
            firstPublishYear: d.first_publish_year,
            coverId: d.cover_i,
            description: nil
        )
    }
}

// MARK: - CoreData → Domain

private extension BookCacheEntity {
    var toDomain: Book {
        Book(
            id: id,
            title: title,
            authors: authors,
            firstPublishYear: firstPublishYear == 0 ? nil : Int(firstPublishYear),
            coverId: coverId == 0 ? nil : Int(coverId),
            description: bookDescription
        )
    }
}

// MARK: - Cached Meta

private struct CachedDetails {
    let book: Book
    let updatedAt: Date
}

private extension BookRepository {
    func cachedDetailsMeta(workId: String) throws -> CachedDetails? {
        let ctx = coreData.container.viewContext

        let req = NSFetchRequest<BookCacheEntity>(
            entityName: "BookCacheEntity"
        )
        req.predicate = NSPredicate(
            format: "kind == %@ AND id == %@",
            "details",
            workId
        )
        req.fetchLimit = 1

        if let item = try ctx.fetch(req).first {
            return CachedDetails(
                book: item.toDomain,
                updatedAt: item.updatedAt
            )
        }
        return nil
    }
}

// MARK: - Query Sanitizer

private extension String {
    var sanitizedQuery: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
    }
}

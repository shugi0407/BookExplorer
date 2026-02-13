import Foundation

enum Endpoints {

    private static let base = URL(string: "https://openlibrary.org")!

    static func feed(page: Int) -> URL {
        var c = URLComponents(url: base.appendingPathComponent("search.json"),
                              resolvingAgainstBaseURL: false)!
        c.queryItems = [
            URLQueryItem(name: "q", value: "harry"), // ✅ not blocked
            URLQueryItem(name: "page", value: "\(page)")
        ]
        return c.url!
    }

    static func search(q: String, page: Int) -> URL {
        var c = URLComponents(url: base.appendingPathComponent("search.json"),
                              resolvingAgainstBaseURL: false)!
        c.queryItems = [
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        return c.url!
    }

    static func workDetails(workId: String) -> URL {
        base.appendingPathComponent("works/\(workId).json")
    }
}

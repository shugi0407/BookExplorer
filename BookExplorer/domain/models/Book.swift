import Foundation

struct Book: Identifiable, Equatable {
    /// Open Library uses "work key" like "/works/OL123W"
    let id: String
    let title: String
    let authors: [String]
    let firstPublishYear: Int?
    let coverId: Int?
    let description: String?

    var coverURL: URL? {
        guard let coverId else { return nil }
        return URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-L.jpg")
    }
}

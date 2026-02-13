import Foundation

// MARK: - Search Response

struct SearchResponseDTO: Decodable {
    let docs: [DocDTO]
}

struct DocDTO: Decodable {
    let key: String?
    let title: String?
    let author_name: [String]?
    let first_publish_year: Int?
    let cover_i: Int?
}

// MARK: - Work Details Response

struct WorkDetailsDTO: Decodable {
    let description: OLDescription?
}

/// OpenLibrary description can be:
/// 1) String
/// 2) { "value": String }
enum OLDescription: Decodable {
    case text(String)

    var stringValue: String {
        switch self {
        case .text(let s): return s
        }
    }

    init(from decoder: Decoder) throws {
        if let s = try? decoder.singleValueContainer().decode(String.self) {
            self = .text(s)
            return
        }

        struct Obj: Decodable { let value: String }
        let obj = try Obj(from: decoder)
        self = .text(obj.value)
    }
}

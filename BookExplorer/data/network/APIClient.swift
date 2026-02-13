import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case badStatus(Int, body: String?)
    case decoding(Error)
    case network(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response."
        case .badStatus(let code, _):
            return "Server returned status \(code)."
        case .decoding:
            return "Failed to parse server data."
        case .network(let e):
            return "Network error: \(e.localizedDescription)"
        }
    }
}

final class APIClient {
    private let tag = "APIClient"

    func get<T: Decodable>(_ url: URL) async throws -> T {
        // ✅ LOG URL (важно для 422)
        print("REQUEST:", url.absoluteString)

        var req = URLRequest(url: url, timeoutInterval: 15)
        req.httpMethod = "GET"

        // ✅ Headers (некоторые сервера режут без User-Agent)
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("BookExplorer/1.0 (iOS; SwiftUI)", forHTTPHeaderField: "User-Agent")

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)

            guard let http = resp as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }

            // ✅ If non-2xx: log body and throw badStatus(code, body)
            guard (200..<300).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8)
                print("STATUS:", http.statusCode, "BODY:", body ?? "<no body>")
                throw APIError.badStatus(http.statusCode, body: body)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                Log.e(tag, "decode failed: \(error)")
                throw APIError.decoding(error)
            }

        } catch let apiError as APIError {
            // ✅ Не заворачиваем наши APIError внутрь network — иначе теряется причина
            Log.e(tag, "request failed: \(apiError)")
            throw apiError

        } catch {
            Log.e(tag, "request failed: \(error)")
            throw APIError.network(error)
        }
    }
}


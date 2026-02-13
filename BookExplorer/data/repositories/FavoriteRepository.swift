import Foundation
import FirebaseDatabase

final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let firebase: FirebaseManager
    private let tag = "FavoriteRepository"

    private var handle: DatabaseHandle?
    private var ref: DatabaseReference?

    init(firebase: FirebaseManager) {
        self.firebase = firebase
    }

    func isFavorite(workId: String, uid: String) async throws -> Bool {
        let path = firebase.db.child("users").child(uid).child("favorites").child(workId.sanitizedKey)
        let snap = try await path.getData()
        return snap.exists()
    }

    func setFavorite(workId: String, uid: String, isFavorite: Bool) async throws {
        let path = firebase.db.child("users").child(uid).child("favorites").child(workId.sanitizedKey)
        if isFavorite {
            try await path.setValue(true)
        } else {
            try await path.removeValue()
        }
    }

    func observeFavorites(uid: String, onChange: @escaping ([String]) -> Void) {
        stopObserving()
        let path = firebase.db.child("users").child(uid).child("favorites")
        ref = path
        handle = path.observe(.value) { snap in
            var ids: [String] = []
            if let dict = snap.value as? [String: Any] {
                ids = dict.keys.map { $0.desanitizeKey }
            }
            onChange(ids.sorted())
        }
    }

    func stopObserving() {
        if let handle, let ref { ref.removeObserver(withHandle: handle) }
        handle = nil
        ref = nil
    }
}

private extension String {
    /// Firebase keys cannot contain some characters; workId contains "/" so sanitize.
    var sanitizedKey: String { self.replacingOccurrences(of: "/", with: "_") }
    var desanitizeKey: String { self.replacingOccurrences(of: "_", with: "/") }
}

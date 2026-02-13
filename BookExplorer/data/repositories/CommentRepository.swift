import Foundation
import FirebaseDatabase

final class CommentRepository: CommentRepositoryProtocol {
    private let firebase: FirebaseManager
    private let tag = "CommentRepository"

    private var handle: DatabaseHandle?
    private var ref: DatabaseReference?

    init(firebase: FirebaseManager) {
        self.firebase = firebase
    }

    func addComment(workId: String, text: String, user: UserProfile) async throws {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { throw ValidationError.invalidComment }
        guard trimmed.count <= 300 else { throw ValidationError.invalidComment }

        let safeWork = workId.sanitizedKey
        let node = firebase.db.child("comments").child(safeWork).childByAutoId()

        let payload: [String: Any] = [
            "userId": user.uid,
            "userEmail": user.email,
            "text": trimmed,
            "createdAt": Int(Date().timeIntervalSince1970 * 1000)
        ]
        try await node.setValue(payload)
    }

    func deleteComment(workId: String, commentId: String, user: UserProfile) async throws {
        let safeWork = workId.sanitizedKey
        let node = firebase.db.child("comments").child(safeWork).child(commentId)

        // Minimal safety: fetch and ensure owner matches before deleting
        let snap = try await node.getData()
        if let dict = snap.value as? [String: Any], let uid = dict["userId"] as? String, uid == user.uid {
            try await node.removeValue()
        } else {
            throw ValidationError.notAllowed
        }
    }

    func observeComments(workId: String, onChange: @escaping ([Comment]) -> Void) {
        stopObserving()
        let safeWork = workId.sanitizedKey
        let node = firebase.db.child("comments").child(safeWork)

        ref = node
        handle = node.observe(.value) { snap in
            var result: [Comment] = []
            for child in snap.children {
                guard let s = child as? DataSnapshot,
                      let dict = s.value as? [String: Any],
                      let uid = dict["userId"] as? String,
                      let email = dict["userEmail"] as? String,
                      let text = dict["text"] as? String,
                      let ms = dict["createdAt"] as? Int
                else { continue }

                result.append(Comment(
                    id: s.key,
                    workId: workId,
                    userId: uid,
                    userEmail: email,
                    text: text,
                    createdAt: Date(timeIntervalSince1970: TimeInterval(ms) / 1000.0)
                ))
            }
            result.sort { $0.createdAt > $1.createdAt }
            onChange(result)
        }
    }

    func stopObserving() {
        if let handle, let ref { ref.removeObserver(withHandle: handle) }
        handle = nil
        ref = nil
    }
}

enum ValidationError: Error, LocalizedError {
    case invalidComment
    case notAllowed

    var errorDescription: String? {
        switch self {
        case .invalidComment: return "Comment must be 2–300 characters."
        case .notAllowed: return "You can only delete your own comments."
        }
    }
}

private extension String {
    var sanitizedKey: String { self.replacingOccurrences(of: "/", with: "_") }
}

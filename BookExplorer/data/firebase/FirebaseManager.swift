import Foundation
import FirebaseAuth
import FirebaseDatabase

final class FirebaseManager {
    private let tag = "FirebaseManager"

    var auth: Auth { Auth.auth() }
    var db: DatabaseReference { Database.database().reference() }

    // Observers
    private var favoritesHandle: DatabaseHandle?
    private var favoritesRef: DatabaseReference?

    private var commentsHandle: DatabaseHandle?
    private var commentsRef: DatabaseReference?

    func stopAll() {
        if let favoritesHandle, let favoritesRef { favoritesRef.removeObserver(withHandle: favoritesHandle) }
        if let commentsHandle, let commentsRef { commentsRef.removeObserver(withHandle: commentsHandle) }
        self.favoritesHandle = nil
        self.favoritesRef = nil
        self.commentsHandle = nil
        self.commentsRef = nil
    }

    deinit { stopAll() }
}

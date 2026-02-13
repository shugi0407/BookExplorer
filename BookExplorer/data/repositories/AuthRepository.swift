import Foundation
import FirebaseAuth

final class AuthRepository: AuthRepositoryProtocol {
    private let firebase: FirebaseManager

    init(firebase: FirebaseManager) {
        self.firebase = firebase
    }

    var currentUser: UserProfile? {
        guard let u = firebase.auth.currentUser, let email = u.email else { return nil }
        return UserProfile(uid: u.uid, email: email)
    }

    func signIn(email: String, password: String) async throws {
        _ = try await firebase.auth.signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        _ = try await firebase.auth.createUser(withEmail: email, password: password)
    }

    func signOut() throws {
        try firebase.auth.signOut()
    }
}

import Foundation
import SwiftUI
import Combine


@MainActor
final class SessionViewModel: ObservableObject {
    private let di: DIContainer

    @Published var user: UserProfile?
    @Published var authError: String?

    init(di: DIContainer) {
        self.di = di
        self.user = di.authRepo.currentUser // session persistence
    }

    func signIn(email: String, password: String) async {
        authError = nil
        do {
            try await di.authRepo.signIn(email: email, password: password)
            user = di.authRepo.currentUser
        } catch {
            authError = error.localizedDescription
        }
    }

    func signUp(email: String, password: String) async {
        authError = nil
        do {
            try await di.authRepo.signUp(email: email, password: password)
            user = di.authRepo.currentUser
        } catch {
            authError = error.localizedDescription
        }
    }

    func signOut() {
        authError = nil
        do {
            try di.authRepo.signOut()
            di.firebase.stopAll()
            user = nil
        } catch {
            authError = error.localizedDescription
        }
    }
}

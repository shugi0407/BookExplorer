import Foundation

protocol AuthRepositoryProtocol {
    var currentUser: UserProfile? { get }
    func signIn(email: String, password: String) async throws
    func signUp(email: String, password: String) async throws
    func signOut() throws
}

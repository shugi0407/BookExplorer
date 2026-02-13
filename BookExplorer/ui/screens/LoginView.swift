import SwiftUI

struct LoginView: View {
    @EnvironmentObject var session: SessionViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    SecureField("Password (min 6)", text: $password)
                }

                if let err = session.authError {
                    Text(err).foregroundStyle(.red)
                }

                Section {
                    Button(isSignUp ? "Create account" : "Sign in") {
                        Task {
                            guard validate() else { return }
                            if isSignUp {
                                await session.signUp(email: email, password: password)
                            } else {
                                await session.signIn(email: email, password: password)
                            }
                        }
                    }
                }

                Section {
                    Toggle("New user (Sign Up)", isOn: $isSignUp)
                }
            }
            .navigationTitle("BookExplorer")
        }
    }

    // Form validation + user-friendly messages (required)
    private func validate() -> Bool {
        session.authError = nil
        if !email.contains("@") { session.authError = "Enter a valid email."; return false }
        if password.count < 6 { session.authError = "Password must be at least 6 characters."; return false }
        return true
    }
}

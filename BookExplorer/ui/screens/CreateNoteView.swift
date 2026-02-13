import SwiftUI
import FirebaseDatabase

struct CreateNoteView: View {
    @EnvironmentObject var session: SessionViewModel
    @State private var title = ""
    @State private var bodyText = ""   // renamed to avoid conflict with `body`
    @State private var message: String?

    private let di = DIContainer.shared

    var body: some View {
        NavigationStack {
            Form {
                Section("Create Note (user-scoped)") {
                    TextField("Title (min 3)", text: $title)
                    TextField("Body (min 5)", text: $bodyText, axis: .vertical)
                        .lineLimit(4...10)
                }

                if let message {
                    Text(message).foregroundStyle(message.contains("Saved") ? .green : .red)
                }

                Section {
                    Button("Save") {
                        Task { await save() }
                    }
                    .disabled(session.user == nil)
                }

                if session.user == nil {
                    Text("Sign in to create notes.")
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Create")
        }
    }

    private func save() async {
        message = nil
        guard let user = session.user else { return }

        let t = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let b = bodyText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard t.count >= 3 else { message = "Title must be at least 3 characters."; return }
        guard b.count >= 5 else { message = "Body must be at least 5 characters."; return }

        do {
            try await di.firebase.db
                .child("users")
                .child(user.uid)
                .child("notes")
                .childByAutoId()
                .setValue([
                    "title": t,
                    "body": b,
                    "createdAt": Int(Date().timeIntervalSince1970 * 1000)
                ])
            title = ""
            bodyText = ""
            message = "Saved ✅"
        } catch {
            message = error.localizedDescription
        }
    }
}

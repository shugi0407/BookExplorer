import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm = ProfileViewModel()

    var body: some View {
        NavigationStack {
            Form {
                if let user = session.user {
                    Section("User") {
                        Text(user.email)
                        Text("UID: \(user.uid)").font(.caption).foregroundStyle(.secondary)
                    }

                    Section("Favorites (IDs)") {
                        if vm.favoriteWorkIds.isEmpty {
                            Text("No favorites yet.").foregroundStyle(.secondary)
                        } else {
                            ForEach(vm.favoriteWorkIds, id: \.self) { id in
                                NavigationLink(id) {
                                    BookDetailView(workId: id)
                                }
                            }
                        }
                    }

                    Section {
                        Button("Sign out", role: .destructive) {
                            session.signOut()
                        }
                    }
                } else {
                    Text("Not signed in.")
                }
            }
            .navigationTitle("Profile")
            .onAppear {
                if let uid = session.user?.uid { vm.start(uid: uid) }
            }
            .onDisappear { vm.stop() }
        }
    }
}

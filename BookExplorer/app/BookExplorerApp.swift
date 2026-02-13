import SwiftUI
import FirebaseCore

@main
struct BookExplorerApp: App {
    @StateObject private var session = SessionViewModel(di: .shared)

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
        }
    }
}

struct RootView: View {
    @EnvironmentObject var session: SessionViewModel

    var body: some View {
        if session.user != nil {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem { Label("Feed", systemImage: "house") }

            SearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }

            CreateNoteView()
                .tabItem { Label("Create", systemImage: "square.and.pencil") }

            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }
    }
}

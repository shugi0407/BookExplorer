import Foundation

enum BuildConfig {
    static var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    /// Example: if you ever swap endpoints between Debug/Release.
    static var apiBaseURL: String {
        // Open Library is public; keeping as constant.
        "https://openlibrary.org"
    }
}

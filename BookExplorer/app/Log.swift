import Foundation

enum Log {
    static func d(_ tag: String, _ message: String) {
        #if DEBUG
        print("DEBUG [\(tag)]: \(message)")
        #endif
    }

    static func e(_ tag: String, _ message: String) {
        // Keep errors in release, but not verbose.
        print("ERROR [\(tag)]: \(message)")
    }
}

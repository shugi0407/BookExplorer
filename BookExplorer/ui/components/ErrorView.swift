import SwiftUI

struct ErrorView: View {
    let message: String
    let retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 12) {
            Text(message).foregroundStyle(.red)
            if let retry {
                Button("Retry", action: retry)
            }
        }
        .padding()
    }
}

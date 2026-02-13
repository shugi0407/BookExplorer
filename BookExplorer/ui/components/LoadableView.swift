import SwiftUI

enum LoadState<T> {
    case idle
    case loading
    case loaded(T)
    case empty(String)
    case failed(String)
}

struct LoadableView<Content: View, T>: View {
    let state: LoadState<T>
    let retry: (() -> Void)?
    let content: (T) -> Content

    var body: some View {
        switch state {
        case .idle:
            ProgressView().onAppear {}
        case .loading:
            ProgressView("Loading…")
        case .loaded(let value):
            content(value)
        case .empty(let msg):
            VStack(spacing: 12) {
                Text(msg).foregroundStyle(.secondary)
                if let retry { Button("Retry", action: retry) }
            }.padding()
        case .failed(let msg):
            VStack(spacing: 12) {
                Text(msg).foregroundStyle(.red)
                if let retry { Button("Retry", action: retry) }
            }.padding()
        }
    }
}

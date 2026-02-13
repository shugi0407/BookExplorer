import SwiftUI

struct FeedView: View {
    @StateObject private var vm = FeedViewModel()

    var body: some View {
        NavigationStack {
            LoadableView(state: vm.state, retry: { Task { await vm.retry() } }) { books in
                List {
                    ForEach(books) { b in
                        NavigationLink {
                            BookDetailView(workId: b.id)
                        } label: {
                            BookRow(book: b)
                                .task { await vm.loadMoreIfNeeded(current: b) } // infinite scroll
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Feed")
            .task { await vm.loadInitial() }
        }
    }
}

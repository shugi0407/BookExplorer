import SwiftUI

struct SearchView: View {
    @StateObject private var vm = SearchViewModel()
    @State private var q = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search books…", text: $q)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onChange(of: q) { _, new in
                        vm.onQueryChanged(new)
                    }

                LoadableView(state: vm.state, retry: { Task { await vm.retry() } }) { books in
                    List {
                        ForEach(books) { b in
                            NavigationLink {
                                BookDetailView(workId: b.id)
                            } label: {
                                BookRow(book: b)
                                    .task { await vm.loadMoreIfNeeded(current: b) }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search")
        }
    }
}

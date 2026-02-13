import SwiftUI
import Kingfisher

struct BookDetailView: View {
    @EnvironmentObject var session: SessionViewModel
    @StateObject private var vm: DetailViewModel
    @State private var commentText = ""

    init(workId: String) {
        _vm = StateObject(wrappedValue: DetailViewModel(workId: workId))
    }

    var body: some View {
        LoadableView(state: vm.state, retry: { Task { await vm.retry(user: session.user) } }) { book in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    KFImage(book.coverURL)
                        .resizable()
                        .placeholder { ProgressView() }
                        .cancelOnDisappear(true)
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)

                    Text(book.title).font(.title2).bold()

                    if !book.authors.isEmpty {
                        Text(book.authors.joined(separator: ", "))
                            .foregroundStyle(.secondary)
                    }

                    if let y = book.firstPublishYear {
                        Text("First published: \(y)").font(.subheadline).foregroundStyle(.secondary)
                    }

                    if let d = book.description, !d.isEmpty {
                        Text(d).font(.body)
                    } else {
                        Text("No description available.")
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    HStack {
                        Button(vm.isFavorite ? "Unfavorite" : "Favorite") {
                            Task { await vm.toggleFavorite(user: session.user) }
                        }
                        .buttonStyle(.borderedProminent)

                        Spacer()
                    }

                    Divider()

                    Text("Realtime Comments").font(.headline)

                    if let err = vm.errorMessage {
                        Text(err).foregroundStyle(.red)
                    }

                    if session.user == nil {
                        Text("Sign in to comment.")
                            .foregroundStyle(.secondary)
                    } else {
                        HStack {
                            TextField("Write a comment…", text: $commentText)
                                .textFieldStyle(.roundedBorder)
                            Button("Send") {
                                let text = commentText
                                commentText = ""
                                Task { await vm.addComment(text: text, user: session.user) }
                            }
                        }
                    }

                    ForEach(vm.comments) { c in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(c.userEmail).font(.subheadline).bold()
                                Spacer()
                                Text(c.createdAt, style: .time).font(.caption).foregroundStyle(.secondary)
                            }
                            Text(c.text)

                            if c.userId == session.user?.uid {
                                Button("Delete") {
                                    Task { await vm.deleteComment(commentId: c.id, user: session.user) }
                                }
                                .font(.caption)
                                .foregroundStyle(.red)
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task { await vm.onAppear(user: session.user) }
        .onDisappear { vm.onDisappear() }
    }
}

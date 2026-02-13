import SwiftUI
import Kingfisher

struct BookRow: View {
    let book: Book

    var body: some View {
        HStack(spacing: 12) {
            KFImage(book.coverURL)
                .resizable()
                .placeholder { ProgressView() }
                .cancelOnDisappear(true)
                .scaledToFill()
                .frame(width: 56, height: 80)
                .clipped()
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(book.title).font(.headline).lineLimit(2)
                if !book.authors.isEmpty {
                    Text(book.authors.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                if let y = book.firstPublishYear {
                    Text("First published: \(y)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
    }
}

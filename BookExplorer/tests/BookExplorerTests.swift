import XCTest
@testable import BookExplorer

final class BookExplorerTests: XCTestCase {
    func testCoverURLNilWhenNoCover() {
        let b = Book(id: "x", title: "t", authors: [], firstPublishYear: nil, coverId: nil, description: nil)
        XCTAssertNil(b.coverURL)
    }

    func testCoverURLBuilds() {
        let b = Book(id: "x", title: "t", authors: [], firstPublishYear: nil, coverId: 12, description: nil)
        XCTAssertTrue(b.coverURL?.absoluteString.contains("/b/id/12-") == true)
    }
}

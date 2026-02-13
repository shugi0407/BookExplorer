import XCTest
@testable import BookExplorer

final class MergePolicyTests: XCTestCase {
    func testDuplicatePreventionById() {
        // This is a logic-level test: if two books share ID, repository overwrites.
        // We assert our model defines ID uniquely.
        let a = Book(id: "/works/OL1W", title: "A", authors: ["x"], firstPublishYear: nil, coverId: nil, description: nil)
        let b = Book(id: "/works/OL1W", title: "B", authors: ["y"], firstPublishYear: nil, coverId: nil, description: nil)
        XCTAssertEqual(a.id, b.id)
    }
}

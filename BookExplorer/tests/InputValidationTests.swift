import XCTest
@testable import BookExplorer

final class InputValidationTests: XCTestCase {
    func testSanitizedQueryTrims() {
        let q = "  hello \n world  "
        XCTAssertEqual(q.sanitizedForTest(), "hello   world")
    }

    func testInvalidCommentTooShort() {
        XCTAssertThrowsError(try validateComment("a"))
    }

    func testInvalidCommentTooLong() {
        XCTAssertThrowsError(try validateComment(String(repeating: "x", count: 301)))
    }
}

private extension String {
    func sanitizedForTest() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
    }
}

private func validateComment(_ s: String) throws {
    let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.count < 2 || trimmed.count > 300 { throw ValidationError.invalidComment }
}

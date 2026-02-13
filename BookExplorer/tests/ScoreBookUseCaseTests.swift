import XCTest
@testable import BookExplorer

final class ScoreBookUseCaseTests: XCTestCase {
    func testScoreBase() {
        let uc = ScoreBookUseCase()
        XCTAssertEqual(uc.score(favoriteCount: 2, commentCount: 3, firstPublishYear: nil), 7)
    }

    func testScoreFreshBonus() {
        let uc = ScoreBookUseCase()
        let current = Calendar.current.component(.year, from: Date())
        XCTAssertEqual(uc.score(favoriteCount: 0, commentCount: 0, firstPublishYear: current), 2)
    }

    func testScoreNoBonusOld() {
        let uc = ScoreBookUseCase()
        XCTAssertEqual(uc.score(favoriteCount: 1, commentCount: 1, firstPublishYear: 1900), 3)
    }
}

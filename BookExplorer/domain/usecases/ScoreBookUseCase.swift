import Foundation

/// Non-trivial business rule (required): recommendation score.
struct ScoreBookUseCase {
    /// score = (favoriteCount * 2) + commentCount + freshnessBonus
    /// freshnessBonus if published within last 7 years (approx proxy; Open Library often lacks exact date)
    func score(favoriteCount: Int, commentCount: Int, firstPublishYear: Int?) -> Int {
        let base = (favoriteCount * 2) + commentCount
        let bonus: Int
        if let year = firstPublishYear {
            let currentYear = Calendar.current.component(.year, from: Date())
            bonus = (currentYear - year) <= 7 ? 2 : 0
        } else {
            bonus = 0
        }
        return base + bonus
    }
}

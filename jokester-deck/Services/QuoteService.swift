import Foundation

struct Quote: Equatable {
    let content: String
    let author: String
}

struct QuoteService {
    /// Bundled quotes only — Quotable.io is unreliable and often fails DNS lookup.
    func fetchDailyQuote(language: AppLanguage) async -> Quote {
        dailyQuote(language: language)
    }

    func fallbackQuote(language: AppLanguage) -> Quote {
        dailyQuote(language: language)
    }

    private func dailyQuote(language: AppLanguage) -> Quote {
        let quotes = LocalizationService.shared.fallbackQuotes(for: language)
        guard !quotes.isEmpty else {
            return Quote(
                content: "Learning the rules is the first step to mastering any game.",
                author: "—"
            )
        }

        let dayIndex = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
        return quotes[dayIndex % quotes.count]
    }
}

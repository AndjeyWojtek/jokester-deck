import Foundation
import SwiftData

@Observable
@MainActor
final class HomeViewModel {
    var quote: Quote?
    var isLoadingQuote = false
    var featuredGame: CardGame?
    var errorMessage: String?
    var isOffline = false

    private let quoteService = QuoteService()

    func loadQuote(language: AppLanguage) async {
        isLoadingQuote = true
        defer { isLoadingQuote = false }

        quote = await quoteService.fetchDailyQuote(language: language)
        isOffline = false
    }

    func pickFeaturedGame(from games: [CardGame], level: Int) {
        featuredGame = GameUnlockService.unlockedGames(from: games, level: level).randomElement()
    }
}

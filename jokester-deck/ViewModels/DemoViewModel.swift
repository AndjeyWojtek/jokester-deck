import Foundation
import SwiftData
import SwiftUI
import UIKit

struct AnimatedCard: Identifiable, Equatable {
    let id = UUID()
    let card: DrawnCard
    var offsetY: CGFloat = 40
    var opacity: Double = 0
}

@Observable
@MainActor
final class DemoViewModel {
    var cards: [AnimatedCard] = []
    var isLoading = false
    var isAnimatingOut = false
    var errorMessage: String?
    var isOffline = false

    private let deckService = DeckAPIService()
    private var deckId: String?
    private var localDeck = LocalDeckService()

    func dealNewHand(reduceMotion: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        if !cards.isEmpty {
            isAnimatingOut = true
            if reduceMotion {
                for index in cards.indices {
                    cards[index].offsetY = 60
                    cards[index].opacity = 0
                }
            } else {
                withAnimation(.easeIn(duration: 0.25)) {
                    for index in cards.indices {
                        cards[index].offsetY = 60
                        cards[index].opacity = 0
                    }
                }
            }
            let delay: Duration = reduceMotion ? .milliseconds(0) : .milliseconds(280)
            try? await Task.sleep(for: delay)
            isAnimatingOut = false
        }

        do {
            if deckId == nil {
                deckId = try await deckService.shuffleDeck()
            }
            let deckId = deckId!
            let drawn = try await deckService.drawCards(deckId: deckId, count: 5)
            applyDealtCards(drawn, reduceMotion: reduceMotion, isOffline: false)
        } catch {
            localDeck.reshuffle()
            let drawn = localDeck.draw(count: 5)
            applyDealtCards(drawn, reduceMotion: reduceMotion, isOffline: true)
            deckId = nil
        }
    }

    private func applyDealtCards(_ drawn: [DrawnCard], reduceMotion: Bool, isOffline: Bool) {
        if reduceMotion {
            cards = drawn.map { AnimatedCard(card: $0, offsetY: 0, opacity: 1) }
        } else {
            cards = drawn.map { AnimatedCard(card: $0, offsetY: 40, opacity: 0) }
        }
        self.isOffline = isOffline
        isLoading = false

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        guard !reduceMotion else { return }

        for index in cards.indices {
            withAnimation(
                .spring(response: 0.4, dampingFraction: 0.7)
                    .delay(Double(index) * 0.08)
            ) {
                cards[index].offsetY = 0
                cards[index].opacity = 1
            }
        }
    }

    func markGameViewed(_ game: CardGame, context: ModelContext, progress: UserProgress?) {
        guard let progress else { return }

        if !progress.gamesViewed.contains(game.id) {
            progress.gamesViewed.append(game.id)
            game.masteryStars = min(game.masteryStars + 1, 3)
            game.xpEarned += 5
            progress.totalXP += 5
            progress.lastPlayedDate = .now
            game.isMastered = game.masteryStars >= 3
            try? context.save()
        }
    }

    func toggleFavorite(_ game: CardGame, progress: UserProgress?, context: ModelContext) {
        guard let progress else { return }
        if progress.favoriteGameIDs.contains(game.id) {
            progress.favoriteGameIDs.removeAll { $0 == game.id }
        } else {
            progress.favoriteGameIDs.append(game.id)
        }
        try? context.save()
    }

    func isFavorite(_ game: CardGame, progress: UserProgress?) -> Bool {
        progress?.favoriteGameIDs.contains(game.id) ?? false
    }
}

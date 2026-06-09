import Foundation

enum MasteryState {
    case catalogLocked
    case locked
    case inProgress
    case mastered
}

@Observable
@MainActor
final class CollectionViewModel {
    func masteryState(for game: CardGame, progress: UserProgress?) -> MasteryState {
        let level = progress?.level ?? 1
        if !GameUnlockService.isUnlocked(game, level: level) {
            return .catalogLocked
        }
        guard let progress else { return .locked }
        if !progress.gamesViewed.contains(game.id) {
            return .locked
        }
        if game.isMastered || game.masteryStars >= 3 {
            return .mastered
        }
        return .inProgress
    }

    func xpProgress(for progress: UserProgress?) -> Double {
        guard let progress else { return 0 }
        return Double(progress.xpInCurrentLevel) / 50.0
    }

    func level(for progress: UserProgress?) -> Int {
        progress?.level ?? 1
    }
}

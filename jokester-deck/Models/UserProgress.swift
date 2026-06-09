import Foundation
import SwiftData

@Model
final class UserProgress {
    var totalXP: Int
    var gamesViewed: [UUID]
    var triviaCorrect: Int
    var triviaTotal: Int
    var lastPlayedDate: Date
    var triviaCompletedGames: [UUID] = []
    var favoriteGameIDs: [UUID] = []

    @Transient
    var level: Int {
        totalXP / 50 + 1
    }

    @Transient
    var xpInCurrentLevel: Int {
        totalXP % 50
    }

    init(
        totalXP: Int = 0,
        gamesViewed: [UUID] = [],
        triviaCorrect: Int = 0,
        triviaTotal: Int = 0,
        lastPlayedDate: Date = .now,
        triviaCompletedGames: [UUID] = [],
        favoriteGameIDs: [UUID] = []
    ) {
        self.totalXP = totalXP
        self.gamesViewed = gamesViewed
        self.triviaCorrect = triviaCorrect
        self.triviaTotal = triviaTotal
        self.lastPlayedDate = lastPlayedDate
        self.triviaCompletedGames = triviaCompletedGames
        self.favoriteGameIDs = favoriteGameIDs
    }
}

import Foundation
import SwiftData

@Model
final class CardGame {
    var id: UUID
    var slug: String = ""
    var name: String
    var emoji: String
    var category: String
    var minPlayers: Int
    var maxPlayers: Int
    var difficultyLevel: Int
    var rules: [String]
    var strategyTips: [String]
    var isMastered: Bool
    var masteryStars: Int
    var xpEarned: Int

    init(
        id: UUID = UUID(),
        slug: String = "",
        name: String,
        emoji: String,
        categoryKey: String,
        minPlayers: Int,
        maxPlayers: Int,
        difficultyLevel: Int,
        rules: [String],
        strategyTips: [String],
        isMastered: Bool = false,
        masteryStars: Int = 0,
        xpEarned: Int = 0
    ) {
        self.id = id
        self.slug = slug
        self.name = name
        self.emoji = emoji
        self.category = categoryKey
        self.minPlayers = minPlayers
        self.maxPlayers = maxPlayers
        self.difficultyLevel = difficultyLevel
        self.rules = rules
        self.strategyTips = strategyTips
        self.isMastered = isMastered
        self.masteryStars = masteryStars
        self.xpEarned = xpEarned
    }
}

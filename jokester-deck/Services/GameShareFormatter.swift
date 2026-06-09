import Foundation

enum GameShareFormatter {
    static func shareText(for game: CardGame) -> String {
        var lines: [String] = [
            "\(game.emoji) \(game.name)",
            String(
                format: LocalizationService.shared.text("demo.playersCategory"),
                "\(game.minPlayers)",
                "\(game.maxPlayers)",
                LocalizationService.shared.localizedCategory(game.category)
            ),
            "",
            LocalizationService.shared.text("demo.howToPlay")
        ]

        for (index, rule) in game.rules.enumerated() {
            lines.append("\(index + 1). \(rule)")
        }

        if !game.strategyTips.isEmpty {
            lines.append("")
            lines.append(LocalizationService.shared.text("collection.strategyTips"))
            for tip in game.strategyTips {
                lines.append("★ \(tip)")
            }
        }

        lines.append("")
        lines.append(LocalizationService.shared.text("share.viaApp"))
        return lines.joined(separator: "\n")
    }
}
